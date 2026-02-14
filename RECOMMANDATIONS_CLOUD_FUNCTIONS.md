# 🚀 Recommandations Google Cloud Functions pour Choose Me

## 📊 État Actuel

### ✅ Ce qui existe
- **Firebase Functions** : Une fonction basique `onUserDeleted` (trigger sur suppression d'utilisateur)
- **Firebase Storage** : Upload direct depuis le client
- **Firestore** : Lecture/écriture directe depuis le client

### ❌ Ce qui manque
- Pas de transcodage vidéo
- Pas de compression d'images
- Pas de génération de thumbnails
- Pas de validation côté serveur
- Pas de traitement asynchrone

---

## 🎯 Pourquoi Utiliser Google Cloud Functions ?

### 1. **Sécurité**
- ✅ Validation côté serveur (impossible à contourner)
- ✅ Clés API cachées (pas exposées au client)
- ✅ Logique métier protégée
- ✅ Rate limiting et quotas

### 2. **Performance**
- ✅ Traitement asynchrone (ne bloque pas l'utilisateur)
- ✅ Parallélisation des tâches
- ✅ Mise en cache
- ✅ Optimisation automatique

### 3. **Fonctionnalités Avancées**
- ✅ Transcodage vidéo (WebM → MP4)
- ✅ Compression d'images
- ✅ Génération de thumbnails
- ✅ Analyse IA (modération, reconnaissance)
- ✅ Notifications push
- ✅ Envoi d'emails

### 4. **Scalabilité**
- ✅ Auto-scaling (s'adapte à la charge)
- ✅ Pas de gestion de serveurs
- ✅ Paiement à l'usage
- ✅ Disponibilité mondiale

---

## 🎬 Cas d'Usage Prioritaires pour Choose Me

### 1. **Transcodage Vidéo** (CRITIQUE)

**Problème actuel :**
- Format WebM non supporté sur Safari/iOS
- Vidéos lourdes (pas de compression)
- Pas de thumbnails automatiques

**Solution avec Cloud Functions :**

```javascript
// firebase/functions/videoProcessing.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const ffmpeg = require('fluent-ffmpeg');
const { Storage } = require('@google-cloud/storage');

exports.processPerformanceVideo = functions
  .region('us-central1')
  .storage
  .object()
  .onFinalize(async (object) => {
    const filePath = object.name;
    
    // Vérifier si c'est une vidéo de performance
    if (!filePath.startsWith('performances/')) return;
    if (filePath.includes('_processed')) return; // Éviter boucle infinie
    
    const bucket = admin.storage().bucket();
    const tempFilePath = `/tmp/${Date.now()}_input.webm`;
    const outputPath = `/tmp/${Date.now()}_output.mp4`;
    const thumbnailPath = `/tmp/${Date.now()}_thumb.jpg`;
    
    try {
      // 1. Télécharger la vidéo
      await bucket.file(filePath).download({ destination: tempFilePath });
      
      // 2. Transcoder en MP4 (compatible partout)
      await new Promise((resolve, reject) => {
        ffmpeg(tempFilePath)
          .outputOptions([
            '-c:v libx264',           // Codec H.264
            '-preset fast',           // Vitesse de compression
            '-crf 23',                // Qualité (18-28, 23 = bon équilibre)
            '-c:a aac',               // Codec audio
            '-b:a 128k',              // Bitrate audio
            '-movflags +faststart',   // Optimisation streaming
            '-vf scale=1080:1920'     // Résolution verticale
          ])
          .output(outputPath)
          .on('end', resolve)
          .on('error', reject)
          .run();
      });
      
      // 3. Générer un thumbnail
      await new Promise((resolve, reject) => {
        ffmpeg(tempFilePath)
          .screenshots({
            timestamps: ['00:00:01'],
            filename: 'thumb.jpg',
            folder: '/tmp',
            size: '540x960'
          })
          .on('end', resolve)
          .on('error', reject);
      });
      
      // 4. Upload MP4 et thumbnail
      const processedPath = filePath.replace('.webm', '_processed.mp4');
      const thumbPath = filePath.replace('.webm', '_thumb.jpg');
      
      await bucket.upload(outputPath, { destination: processedPath });
      await bucket.upload(thumbnailPath, { destination: thumbPath });
      
      // 5. Mettre à jour Firestore avec les nouvelles URLs
      const videoUrl = await bucket.file(processedPath).getSignedUrl({
        action: 'read',
        expires: '03-01-2500'
      });
      
      const thumbnailUrl = await bucket.file(thumbPath).getSignedUrl({
        action: 'read',
        expires: '03-01-2500'
      });
      
      // Extraire userId et docId du path
      const pathParts = filePath.split('/');
      const userId = pathParts[1];
      const fileName = pathParts[2];
      
      // Trouver le document Firestore correspondant
      const performancesRef = admin.firestore()
        .collection('users')
        .doc(userId)
        .collection('performances');
      
      const snapshot = await performancesRef
        .where('videoUrl', '==', object.mediaLink)
        .limit(1)
        .get();
      
      if (!snapshot.empty) {
        const docId = snapshot.docs[0].id;
        await performancesRef.doc(docId).update({
          videoUrl: videoUrl[0],
          thumbnailUrl: thumbnailUrl[0],
          processed: true,
          format: 'mp4'
        });
      }
      
      console.log('✅ Vidéo traitée avec succès');
      
    } catch (error) {
      console.error('❌ Erreur traitement vidéo:', error);
    }
  });
```

**Avantages :**
- ✅ Compatibilité universelle (MP4 fonctionne partout)
- ✅ Vidéos plus légères (meilleure compression)
- ✅ Thumbnails automatiques
- ✅ Traitement transparent pour l'utilisateur
- ✅ Pas de modification du code client

---

### 2. **Compression d'Images**

**Problème actuel :**
- Photos de profil lourdes
- Pas de redimensionnement automatique
- Pas de formats optimisés (WebP)

**Solution avec Cloud Functions :**

```javascript
// firebase/functions/imageProcessing.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const sharp = require('sharp');

exports.processProfileImage = functions
  .region('us-central1')
  .storage
  .object()
  .onFinalize(async (object) => {
    const filePath = object.name;
    
    if (!filePath.startsWith('profiles/')) return;
    if (filePath.includes('_thumb')) return;
    
    const bucket = admin.storage().bucket();
    const tempFilePath = `/tmp/${Date.now()}_input`;
    const outputPath = `/tmp/${Date.now()}_output.webp`;
    const thumbPath = `/tmp/${Date.now()}_thumb.webp`;
    
    try {
      await bucket.file(filePath).download({ destination: tempFilePath });
      
      // Créer version optimisée (800x800)
      await sharp(tempFilePath)
        .resize(800, 800, { fit: 'cover' })
        .webp({ quality: 85 })
        .toFile(outputPath);
      
      // Créer thumbnail (200x200)
      await sharp(tempFilePath)
        .resize(200, 200, { fit: 'cover' })
        .webp({ quality: 80 })
        .toFile(thumbPath);
      
      // Upload
      const optimizedPath = filePath.replace(/\.[^.]+$/, '_optimized.webp');
      const thumbnailPath = filePath.replace(/\.[^.]+$/, '_thumb.webp');
      
      await bucket.upload(outputPath, { destination: optimizedPath });
      await bucket.upload(thumbPath, { destination: thumbnailPath });
      
      console.log('✅ Image traitée avec succès');
      
    } catch (error) {
      console.error('❌ Erreur traitement image:', error);
    }
  });
```

---

### 3. **Modération de Contenu**

**Utiliser Google Cloud Vision API pour détecter :**
- Contenu inapproprié
- Violence
- Contenu pour adultes
- Texte dans les images

```javascript
// firebase/functions/moderation.js
const functions = require('firebase-functions');
const vision = require('@google-cloud/vision');

exports.moderateVideo = functions
  .region('us-central1')
  .firestore
  .document('users/{userId}/performances/{videoId}')
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const client = new vision.ImageAnnotatorClient();
    
    // Analyser le thumbnail
    const [result] = await client.safeSearchDetection(data.thumbnailUrl);
    const detections = result.safeSearchAnnotation;
    
    // Vérifier si contenu inapproprié
    const isInappropriate = 
      detections.adult === 'VERY_LIKELY' ||
      detections.violence === 'VERY_LIKELY';
    
    if (isInappropriate) {
      // Marquer pour modération
      await snap.ref.update({
        moderated: true,
        moderationStatus: 'flagged',
        visible: false
      });
      
      // Notifier les admins
      await admin.firestore().collection('moderation').add({
        type: 'video',
        userId: context.params.userId,
        videoId: context.params.videoId,
        reason: 'inappropriate_content',
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      });
    }
  });
```

---

### 4. **Notifications Push**

```javascript
// firebase/functions/notifications.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');

exports.notifyNewFollower = functions
  .region('us-central1')
  .firestore
  .document('users/{userId}/followers/{followerId}')
  .onCreate(async (snap, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;
    
    // Récupérer le token FCM de l'utilisateur
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(userId)
      .get();
    
    const fcmToken = userDoc.data()?.fcmToken;
    if (!fcmToken) return;
    
    // Récupérer le nom du follower
    const followerDoc = await admin.firestore()
      .collection('users')
      .doc(followerId)
      .get();
    
    const followerName = followerDoc.data()?.displayName || 'Quelqu\'un';
    
    // Envoyer la notification
    await admin.messaging().send({
      token: fcmToken,
      notification: {
        title: 'Nouveau follower',
        body: `${followerName} vous suit maintenant !`
      },
      data: {
        type: 'new_follower',
        followerId: followerId
      }
    });
  });
```

---

### 5. **Analyse IA avec Gemini**

```javascript
// firebase/functions/aiAnalysis.js
const functions = require('firebase-functions');
const { GoogleGenerativeAI } = require('@google/generative-ai');

exports.generateTalentInsight = functions
  .region('us-central1')
  .https
  .onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'Utilisateur non authentifié');
    }
    
    const genAI = new GoogleGenerativeAI(functions.config().gemini.key);
    const model = genAI.getGenerativeModel({ model: 'gemini-pro' });
    
    const prompt = `Analyse ce profil de joueur et génère un rapport de scoutisme professionnel:
    Nom: ${data.name}
    Stats: ${JSON.stringify(data.stats)}
    Sport: ${data.sport}
    Position: ${data.position}`;
    
    const result = await model.generateContent(prompt);
    const response = await result.response;
    
    return { insight: response.text() };
  });
```

---

## 📦 Installation et Configuration

### 1. **Installer Firebase CLI**

```bash
npm install -g firebase-tools
firebase login
```

### 2. **Initialiser Functions**

```bash
cd firebase/functions
npm install
npm install fluent-ffmpeg sharp @google-cloud/vision @google/generative-ai
```

### 3. **Configurer package.json**

```json
{
  "name": "functions",
  "engines": {
    "node": "18"
  },
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^4.5.0",
    "fluent-ffmpeg": "^2.1.2",
    "sharp": "^0.33.0",
    "@google-cloud/vision": "^4.0.0",
    "@google/generative-ai": "^0.1.0"
  }
}
```

### 4. **Déployer**

```bash
# Déployer toutes les functions
firebase deploy --only functions -P choose-me-l1izsi

# Déployer une function spécifique
firebase deploy --only functions:processPerformanceVideo -P choose-me-l1izsi
```

---

## 💰 Coûts Estimés

### **Firebase Functions (Gratuit jusqu'à)**
- 2 millions d'invocations/mois
- 400 000 Go-secondes/mois
- 200 000 GHz-secondes/mois

### **Au-delà (Tarifs)**
- $0.40 par million d'invocations
- $0.0000025 par Go-seconde
- $0.0000100 par GHz-seconde

### **Estimation pour Choose Me**
Avec 1000 utilisateurs actifs uploadant 5 vidéos/mois :
- 5000 vidéos/mois
- ~$2-5/mois (largement dans le gratuit)

---

## 🎯 Plan d'Implémentation Recommandé

### **Phase 1 : Transcodage Vidéo** (PRIORITAIRE)
1. Créer `processPerformanceVideo` function
2. Installer ffmpeg dans l'environnement Cloud Functions
3. Tester avec quelques vidéos
4. Déployer en production

### **Phase 2 : Compression Images**
1. Créer `processProfileImage` function
2. Utiliser Sharp pour optimisation
3. Générer thumbnails automatiques

### **Phase 3 : Modération**
1. Intégrer Cloud Vision API
2. Créer système de flagging
3. Dashboard admin pour modération

### **Phase 4 : Notifications**
1. Implémenter FCM (Firebase Cloud Messaging)
2. Créer triggers pour événements importants
3. Personnaliser les notifications

### **Phase 5 : IA Avancée**
1. Intégrer Gemini pour analyses
2. Recommandations personnalisées
3. Détection automatique de talents

---

## ✅ Avantages Immédiats

1. **Compatibilité Safari/iOS** - Vidéos MP4 fonctionnent partout
2. **Performances** - Vidéos plus légères, chargement plus rapide
3. **Expérience utilisateur** - Thumbnails automatiques
4. **Sécurité** - Modération automatique
5. **Scalabilité** - Prêt pour des milliers d'utilisateurs

---

## 🚀 Conclusion

**OUI, vous devriez absolument utiliser Google Cloud Functions !**

Les bénéfices sont énormes, surtout pour :
- ✅ Le transcodage vidéo (résout le problème Safari/iOS)
- ✅ L'optimisation des performances
- ✅ La sécurité et la modération
- ✅ L'évolutivité de l'application

**Coût :** Quasi gratuit pour commencer, très abordable en production.

**Complexité :** Moyenne, mais Firebase facilite grandement le déploiement.

**ROI :** Excellent - améliore drastiquement l'expérience utilisateur.

---

## 📞 Prochaines Étapes

1. **Lire ce document** ✅
2. **Décider des priorités** (je recommande : transcodage vidéo d'abord)
3. **Installer les dépendances** (voir section Installation)
4. **Implémenter la première function** (je peux vous aider)
5. **Tester et déployer**

Voulez-vous que je commence par implémenter le transcodage vidéo ? 🎬
