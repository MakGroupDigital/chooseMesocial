const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");
const path = require("path");
const os = require("os");
const fs = require("fs");
const spawn = require("child-process-promise").spawn;

admin.initializeApp();

const storage = new Storage();

/**
 * Fonction de transcodage vidéo
 * Convertit les vidéos WebM en MP4 et génère des thumbnails
 */
exports.processPerformanceVideo = functions
  .region("us-central1")
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB"
  })
  .storage
  .bucket() // Utiliser le bucket par défaut
  .object()
  .onFinalize(async (object) => {
    const filePath = object.name;
    const contentType = object.contentType;

    console.log("📹 Nouveau fichier détecté:", filePath);

    // Vérifier si c'est une vidéo de performance
    if (!filePath.startsWith("performances/")) {
      console.log("❌ Pas une vidéo de performance, ignoré");
      return null;
    }

    // Éviter la boucle infinie (ne pas traiter les vidéos déjà traitées)
    if (filePath.includes("_processed") || filePath.includes("_thumb")) {
      console.log("✅ Vidéo déjà traitée, ignoré");
      return null;
    }

    // Vérifier que c'est bien une vidéo
    if (!contentType || !contentType.startsWith("video/")) {
      console.log("❌ Pas une vidéo, ignoré");
      return null;
    }

    const bucket = admin.storage().bucket(object.bucket);
    const fileName = path.basename(filePath);
    const fileDir = path.dirname(filePath);
    
    // Chemins temporaires
    const tempInputPath = path.join(os.tmpdir(), `input_${Date.now()}_${fileName}`);
    const tempOutputPath = path.join(os.tmpdir(), `output_${Date.now()}.mp4`);
    const tempThumbPath = path.join(os.tmpdir(), `thumb_${Date.now()}.jpg`);

    try {
      console.log("⬇️ Téléchargement de la vidéo...");
      await bucket.file(filePath).download({ destination: tempInputPath });
      console.log("✅ Vidéo téléchargée");

      // 1. Transcoder en MP4
      console.log("🎬 Transcodage en MP4...");
      await spawn("ffmpeg", [
        "-i", tempInputPath,
        "-c:v", "libx264",           // Codec H.264
        "-preset", "fast",           // Vitesse de compression
        "-crf", "23",                // Qualité (18-28, 23 = bon équilibre)
        "-c:a", "aac",               // Codec audio
        "-b:a", "128k",              // Bitrate audio
        "-movflags", "+faststart",   // Optimisation streaming
        "-vf", "scale='min(1080,iw)':'min(1920,ih)':force_original_aspect_ratio=decrease",
        "-y",                        // Overwrite
        tempOutputPath
      ], { capture: ["stdout", "stderr"] });
      console.log("✅ Transcodage terminé");

      // 2. Générer un thumbnail
      console.log("📸 Génération du thumbnail...");
      await spawn("ffmpeg", [
        "-i", tempInputPath,
        "-ss", "00:00:01",           // Prendre à 1 seconde
        "-vframes", "1",             // Une seule frame
        "-vf", "scale=540:960:force_original_aspect_ratio=decrease",
        "-y",
        tempThumbPath
      ], { capture: ["stdout", "stderr"] });
      console.log("✅ Thumbnail généré");

      // 3. Upload MP4
      const processedFileName = fileName.replace(/\.[^.]+$/, "_processed.mp4");
      const processedPath = path.join(fileDir, processedFileName);
      
      console.log("⬆️ Upload MP4...");
      await bucket.upload(tempOutputPath, {
        destination: processedPath,
        metadata: {
          contentType: "video/mp4",
          metadata: {
            originalFile: filePath
          }
        }
      });
      console.log("✅ MP4 uploadé");

      // 4. Upload thumbnail
      const thumbFileName = fileName.replace(/\.[^.]+$/, "_thumb.jpg");
      const thumbPath = path.join(fileDir, thumbFileName);
      
      console.log("⬆️ Upload thumbnail...");
      await bucket.upload(tempThumbPath, {
        destination: thumbPath,
        metadata: {
          contentType: "image/jpeg"
        }
      });
      console.log("✅ Thumbnail uploadé");

      // 5. Obtenir les URLs publiques
      const [processedFile] = await bucket.file(processedPath).get();
      const [thumbFile] = await bucket.file(thumbPath).get();
      
      const processedUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(processedPath)}?alt=media`;
      const thumbUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(thumbPath)}?alt=media`;

      // 6. Mettre à jour Firestore
      console.log("💾 Mise à jour Firestore...");
      
      // Extraire userId du path (performances/userId/filename)
      const pathParts = filePath.split("/");
      if (pathParts.length >= 3) {
        const userId = pathParts[1];
        
        // Trouver le document correspondant
        const performancesRef = admin.firestore()
          .collection("users")
          .doc(userId)
          .collection("performances");
        
        // Chercher par l'URL originale
        const originalUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(filePath)}?alt=media`;
        
        const snapshot = await performancesRef
          .where("videoUrl", "==", originalUrl)
          .limit(1)
          .get();
        
        if (!snapshot.empty) {
          const docId = snapshot.docs[0].id;
          await performancesRef.doc(docId).update({
            videoUrl: processedUrl,
            thumbnailUrl: thumbUrl,
            processed: true,
            format: "mp4",
            processedAt: admin.firestore.FieldValue.serverTimestamp()
          });
          console.log("✅ Firestore mis à jour");
        } else {
          console.log("⚠️ Document Firestore non trouvé");
        }
      }

      // 7. Nettoyer les fichiers temporaires
      fs.unlinkSync(tempInputPath);
      fs.unlinkSync(tempOutputPath);
      fs.unlinkSync(tempThumbPath);
      console.log("🧹 Fichiers temporaires nettoyés");

      console.log("🎉 Traitement vidéo terminé avec succès!");
      return null;

    } catch (error) {
      console.error("❌ Erreur lors du traitement:", error);
      
      // Nettoyer les fichiers temporaires en cas d'erreur
      try {
        if (fs.existsSync(tempInputPath)) fs.unlinkSync(tempInputPath);
        if (fs.existsSync(tempOutputPath)) fs.unlinkSync(tempOutputPath);
        if (fs.existsSync(tempThumbPath)) fs.unlinkSync(tempThumbPath);
      } catch (cleanupError) {
        console.error("Erreur nettoyage:", cleanupError);
      }
      
      throw error;
    }
  });

/**
 * Fonction de nettoyage lors de la suppression d'un utilisateur
 */
exports.onUserDeleted = functions
  .region("us-central1")
  .auth.user()
  .onDelete(async (user) => {
    const firestore = admin.firestore();
    const storage = admin.storage();
    
    try {
      console.log("🗑️ Suppression des données utilisateur:", user.uid);
      
      // Supprimer le document utilisateur
      await firestore.doc(`users/${user.uid}`).delete();
      
      // Supprimer les vidéos de performance
      const bucket = storage.bucket();
      await bucket.deleteFiles({
        prefix: `performances/${user.uid}/`
      });
      
      console.log("✅ Données utilisateur supprimées");
    } catch (error) {
      console.error("❌ Erreur suppression utilisateur:", error);
    }
  });

/**
 * Fonction de notification pour nouveau follower
 */
exports.notifyNewFollower = functions
  .region("us-central1")
  .firestore
  .document("users/{userId}/followers/{followerId}")
  .onCreate(async (snap, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;
    
    try {
      console.log(`👥 Nouveau follower: ${followerId} suit ${userId}`);
      
      // Récupérer les infos du follower
      const followerDoc = await admin.firestore()
        .collection("users")
        .doc(followerId)
        .get();
      
      const followerName = followerDoc.data()?.displayName || "Quelqu'un";
      
      // Récupérer le token FCM de l'utilisateur
      const userDoc = await admin.firestore()
        .collection("users")
        .doc(userId)
        .get();
      
      const fcmToken = userDoc.data()?.fcmToken;
      
      if (fcmToken) {
        await admin.messaging().send({
          token: fcmToken,
          notification: {
            title: "Nouveau follower",
            body: `${followerName} vous suit maintenant !`
          },
          data: {
            type: "new_follower",
            followerId: followerId
          }
        });
        console.log("✅ Notification envoyée");
      } else {
        console.log("⚠️ Pas de token FCM pour cet utilisateur");
      }
    } catch (error) {
      console.error("❌ Erreur notification:", error);
    }
  });

/**
 * Cloud Function déclenchée quand un match est mis à jour
 * Traite automatiquement les pronostics quand un match se termine
 */
exports.processMatchResults = functions
  .region("us-central1")
  .firestore
  .document('matches/{matchId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    const matchId = context.params.matchId;

    // Vérifier si le match vient de se terminer
    if (before.status !== 'finished' && after.status === 'finished') {
      console.log(`🏁 Match terminé: ${matchId}`);
      
      try {
        // Déterminer le résultat
        let result;
        if (after.score_a > after.score_b) {
          result = 'team_a';
        } else if (after.score_b > after.score_a) {
          result = 'team_b';
        } else {
          result = 'draw';
        }

        console.log(`📊 Résultat: ${result} (${after.score_a}-${after.score_b})`);

        // Récupérer tous les pronostics en attente pour ce match
        const pronosticsSnapshot = await admin.firestore().collection('pronostics')
          .where('match_ref', '==', admin.firestore().doc(`matches/${matchId}`))
          .where('status', '==', 'pending')
          .get();

        console.log(`🎯 ${pronosticsSnapshot.size} pronostics à traiter`);

        const batch = admin.firestore().batch();
        const rewardPromises = [];

        pronosticsSnapshot.docs.forEach(doc => {
          const pronostic = doc.data();
          const isWinner = pronostic.prediction === result;
          const newStatus = isWinner ? 'won' : 'lost';

          // Mettre à jour le pronostic
          batch.update(doc.ref, {
            status: newStatus,
            processed_at: admin.firestore.FieldValue.serverTimestamp(),
          });

          // Si gagnant, créditer le portefeuille (10 points par victoire)
          if (isWinner) {
            rewardPromises.push(
              creditUserWallet(
                pronostic.user_ref.id,
                10,  // 10 points par pronostic gagné
                'correct_prediction',
                `Pronostic gagnant: ${after.team_a_name} vs ${after.team_b_name}`,
                matchId
              )
            );
          }
        });

        // Exécuter le batch
        await batch.commit();

        // Créditer les portefeuilles
        await Promise.all(rewardPromises);

        console.log(`✅ Pronostics traités avec succès`);

        return { success: true, processed: pronosticsSnapshot.size };
      } catch (error) {
        console.error('❌ Erreur traitement pronostics:', error);
        throw error;
      }
    }

    return null;
  });

/**
 * Crédite le portefeuille d'un utilisateur
 */
async function creditUserWallet(userId, amount, rewardType, description, matchId) {
  try {
    const db = admin.firestore();
    
    // NOUVELLE LOGIQUE: 1 pronostic gagné = 10 points
    const pointsToAdd = 10;
    
    // Récupérer ou créer le portefeuille
    const walletsSnapshot = await db.collection('wallets')
      .where('user_ref', '==', db.doc(`users/${userId}`))
      .limit(1)
      .get();

    let walletRef;
    let currentPoints = 0;

    if (walletsSnapshot.empty) {
      // Créer un nouveau portefeuille
      walletRef = await db.collection('wallets').add({
        user_ref: db.doc(`users/${userId}`),
        points: 0,
        created_at: admin.firestore.FieldValue.serverTimestamp(),
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      walletRef = walletsSnapshot.docs[0].ref;
      const walletData = walletsSnapshot.docs[0].data();
      currentPoints = walletData.points || 0;
    }

    // Utiliser une transaction pour garantir la cohérence
    await db.runTransaction(async (transaction) => {
      const walletDoc = await transaction.get(walletRef);
      
      if (!walletDoc.exists) {
        throw new Error('Portefeuille introuvable');
      }

      const newPoints = currentPoints + pointsToAdd;

      // Mettre à jour le portefeuille
      transaction.update(walletRef, {
        points: newPoints,
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Créer une transaction
      const transactionRef = db.collection('transactions').doc();
      transaction.set(transactionRef, {
        wallet_ref: walletRef,
        user_ref: db.doc(`users/${userId}`),
        type: 'credit',
        amount: pointsToAdd,
        reward_type: rewardType,
        description,
        match_ref: matchId ? db.doc(`matches/${matchId}`) : null,
        created_at: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    console.log(`💰 Portefeuille crédité: +${pointsToAdd} points pour ${userId}`);
    return { success: true };
  } catch (error) {
    console.error(`❌ Erreur crédit portefeuille pour ${userId}:`, error);
    throw error;
  }
}

/**
 * Cloud Function pour synchroniser les matchs depuis l'API
 * Déclenchée toutes les 5 minutes
 */
exports.syncMatches = functions
  .region("us-central1")
  .runWith({
    timeoutSeconds: 300,
    memory: "512MB"
  })
  .pubsub
  .schedule('every 5 minutes')
  .onRun(async (context) => {
    console.log('🔄 Début synchronisation matchs...');

    try {
      const https = require('https');
      const today = new Date().toISOString().split('T')[0];

      // Ligues supportées
      const leagues = {
        'Premier League': '4328',
        'La Liga': '4335',
        'Bundesliga': '4331',
        'Serie A': '4332',
        'Ligue 1': '4334',
      };

      let totalMatches = 0;

      for (const [leagueName, leagueId] of Object.entries(leagues)) {
        const url = `https://www.thesportsdb.com/api/v1/json/3/eventsday.php?d=${today}&l=${leagueId}`;

        const data = await new Promise((resolve, reject) => {
          https.get(url, (res) => {
            let body = '';
            res.on('data', chunk => body += chunk);
            res.on('end', () => {
              try {
                resolve(JSON.parse(body));
              } catch (e) {
                reject(e);
              }
            });
          }).on('error', reject);
        });

        if (data.events && Array.isArray(data.events)) {
          for (const event of data.events) {
            await syncMatch(event, leagueName);
            totalMatches++;
          }
        }
      }

      console.log(`✅ Synchronisation terminée: ${totalMatches} matchs`);
      return { success: true, matches: totalMatches };
    } catch (error) {
      console.error('❌ Erreur synchronisation:', error);
      throw error;
    }
  });

/**
 * Cloud Function pour traiter les retraits
 * Déclenchée quand un retrait est créé
 */
exports.processWithdrawal = functions
  .region("us-central1")
  .firestore
  .document('withdrawals/{withdrawalId}')
  .onCreate(async (snap, context) => {
    const withdrawalId = context.params.withdrawalId;
    const withdrawalData = snap.data();
    
    try {
      console.log(`💸 Nouveau retrait: ${withdrawalId}`);
      
      const db = admin.firestore();
      const userId = withdrawalData.user_ref.id;
      const amount = withdrawalData.amount;
      
      // Récupérer le wallet
      const walletsSnapshot = await db.collection('wallets')
        .where('user_ref', '==', withdrawalData.user_ref)
        .limit(1)
        .get();
      
      if (walletsSnapshot.empty) {
        throw new Error('Portefeuille introuvable');
      }
      
      const walletRef = walletsSnapshot.docs[0].ref;
      const walletData = walletsSnapshot.docs[0].data();
      const currentPoints = walletData.points || 0;
      
      // Vérifier le solde
      if (currentPoints < amount) {
        await snap.ref.update({
          status: 'rejected',
          rejection_reason: 'Solde insuffisant',
          processed_at: admin.firestore.FieldValue.serverTimestamp(),
        });
        return;
      }
      
      // Créer une transaction de débit
      await db.collection('transactions').add({
        wallet_ref: walletRef,
        user_ref: db.doc(`users/${userId}`),
        type: 'debit',
        amount: amount,
        reward_type: 'withdrawal',
        description: `Retrait ${withdrawalData.method} - ${withdrawalData.account_details}`,
        withdrawal_ref: snap.ref,
        created_at: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      console.log(`✅ Transaction de retrait créée pour ${userId}`);
      
      // Note: Le statut reste 'pending' jusqu'à validation manuelle admin
      // L'admin devra mettre à jour le statut à 'completed' après paiement
      
    } catch (error) {
      console.error(`❌ Erreur traitement retrait ${withdrawalId}:`, error);
      await snap.ref.update({
        status: 'rejected',
        rejection_reason: error.message,
        processed_at: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  });

/**
 * Cloud Function pour finaliser un retrait
 * Déclenchée quand un retrait passe à 'completed'
 */
exports.completeWithdrawal = functions
  .region("us-central1")
  .firestore
  .document('withdrawals/{withdrawalId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    
    // Vérifier si le statut est passé à 'completed'
    if (before.status !== 'completed' && after.status === 'completed') {
      try {
        const db = admin.firestore();
        const userId = after.user_ref.id;
        const amount = after.amount;
        
        // Récupérer le wallet
        const walletsSnapshot = await db.collection('wallets')
          .where('user_ref', '==', after.user_ref)
          .limit(1)
          .get();
        
        if (!walletsSnapshot.empty) {
          const walletRef = walletsSnapshot.docs[0].ref;
          const walletData = walletsSnapshot.docs[0].data();
          const currentPoints = walletData.points || 0;
          
          // Débiter le wallet
          await walletRef.update({
            points: currentPoints - amount,
            updated_at: admin.firestore.FieldValue.serverTimestamp(),
          });
          
          console.log(`✅ Wallet débité: -${amount} points pour ${userId}`);
        }
      } catch (error) {
        console.error('❌ Erreur finalisation retrait:', error);
      }
    }
  });
async function syncMatch(event, leagueName) {
  try {
    const db = admin.firestore();
    const matchId = event.idEvent;

    // Vérifier si le match existe
    const matchRef = db.collection('matches').doc(matchId);
    const matchDoc = await matchRef.get();

    // Parser la date
    let startTime = new Date();
    if (event.dateEvent) {
      startTime = new Date(event.dateEvent);
      if (event.strTime) {
        const [hours, minutes] = event.strTime.split(':');
        startTime.setHours(parseInt(hours), parseInt(minutes));
      }
    }

    // Déterminer le statut
    let status = 'scheduled';
    const statusStr = event.strStatus || '';
    if (statusStr.includes('FT') || statusStr.includes('Finished')) {
      status = 'finished';
    } else if (statusStr.includes('Live') || statusStr.includes('1H') || statusStr.includes('2H')) {
      status = 'live';
    }

    const matchData = {
      external_id: matchId,
      team_a_name: event.strHomeTeam || '',
      team_a_logo: event.strHomeTeamBadge || event.strThumb || '',
      team_b_name: event.strAwayTeam || '',
      team_b_logo: event.strAwayTeamBadge || '',
      competition: leagueName,
      start_time: admin.firestore.Timestamp.fromDate(startTime),
      status,
      score_a: parseInt(event.intHomeScore || '0'),
      score_b: parseInt(event.intAwayScore || '0'),
      match_minute: 0,
      predictions_enabled: true,
      reward_amount: 100,
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    };

    if (matchDoc.exists) {
      // Mettre à jour
      await matchRef.update(matchData);
    } else {
      // Créer
      matchData.created_at = admin.firestore.FieldValue.serverTimestamp();
      await matchRef.set(matchData);
    }
  } catch (error) {
    console.error(`Erreur sync match ${event.idEvent}:`, error);
  }
}
