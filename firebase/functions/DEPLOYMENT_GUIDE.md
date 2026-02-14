# 🚀 Guide de Déploiement Cloud Functions

## 📋 Prérequis

### 1. **Installer Firebase CLI**
```bash
npm install -g firebase-tools
firebase login
```

### 2. **Installer FFmpeg sur Cloud Functions**

FFmpeg n'est pas inclus par défaut dans l'environnement Cloud Functions. Il faut l'installer via un buildpack.

**Créer `.buildpacks` dans le dossier functions :**

```bash
cd firebase/functions
echo "https://github.com/jonathanong/heroku-buildpack-ffmpeg-latest.git" > .buildpacks
```

**OU utiliser l'extension Firebase :**

```bash
firebase ext:install firebase/storage-resize-images
```

---

## 📦 Installation des Dépendances

```bash
cd firebase/functions
npm install
```

**Dépendances ajoutées :**
- `@google-cloud/storage` - Gestion du Storage
- `child-process-promise` - Exécution de FFmpeg

---

## 🔧 Configuration

### 1. **Vérifier firebase.json**

Le fichier `firebase.json` à la racine doit contenir :

```json
{
  "functions": {
    "source": "firebase/functions",
    "runtime": "nodejs20",
    "predeploy": [
      "npm --prefix \"$RESOURCE_DIR\" run lint"
    ]
  }
}
```

### 2. **Augmenter les quotas (si nécessaire)**

Les fonctions de transcodage vidéo nécessitent :
- **Timeout :** 540 secondes (9 minutes)
- **Mémoire :** 2GB
- **Région :** us-central1

Ces paramètres sont déjà configurés dans `index.js`.

---

## 🚀 Déploiement

### **Option 1 : Déployer toutes les functions**

```bash
firebase deploy --only functions -P choose-me-l1izsi
```

### **Option 2 : Déployer une function spécifique**

```bash
# Déployer uniquement le transcodage vidéo
firebase deploy --only functions:processPerformanceVideo -P choose-me-l1izsi

# Déployer uniquement les notifications
firebase deploy --only functions:notifyNewFollower -P choose-me-l1izsi
```

### **Option 3 : Déployer avec logs détaillés**

```bash
firebase deploy --only functions -P choose-me-l1izsi --debug
```

---

## 🧪 Test en Local

### 1. **Démarrer l'émulateur**

```bash
cd firebase/functions
npm run serve
```

### 2. **Tester l'upload**

1. Ouvrir l'interface de l'émulateur : http://localhost:4000
2. Aller dans Storage
3. Uploader une vidéo dans `performances/testUserId/test.webm`
4. Observer les logs dans le terminal

---

## 📊 Vérification du Déploiement

### 1. **Vérifier les functions déployées**

```bash
firebase functions:list -P choose-me-l1izsi
```

**Résultat attendu :**
```
┌────────────────────────────────┬────────────┬─────────────┐
│ Function                       │ Region     │ Trigger     │
├────────────────────────────────┼────────────┼─────────────┤
│ processPerformanceVideo        │ us-central1│ Storage     │
│ onUserDeleted                  │ us-central1│ Auth        │
│ notifyNewFollower              │ us-central1│ Firestore   │
└────────────────────────────────┴────────────┴─────────────┘
```

### 2. **Voir les logs en temps réel**

```bash
firebase functions:log -P choose-me-l1izsi --only processPerformanceVideo
```

### 3. **Tester avec une vraie vidéo**

1. Ouvrir l'app web
2. Enregistrer une vidéo de performance
3. Vérifier les logs :
   ```bash
   firebase functions:log -P choose-me-l1izsi
   ```

**Logs attendus :**
```
📹 Nouveau fichier détecté: performances/userId/timestamp_performance.webm
⬇️ Téléchargement de la vidéo...
✅ Vidéo téléchargée
🎬 Transcodage en MP4...
✅ Transcodage terminé
📸 Génération du thumbnail...
✅ Thumbnail généré
⬆️ Upload MP4...
✅ MP4 uploadé
⬆️ Upload thumbnail...
✅ Thumbnail uploadé
💾 Mise à jour Firestore...
✅ Firestore mis à jour
🧹 Fichiers temporaires nettoyés
🎉 Traitement vidéo terminé avec succès!
```

---

## 🐛 Dépannage

### **Problème 1 : FFmpeg non trouvé**

**Erreur :**
```
Error: spawn ffmpeg ENOENT
```

**Solution :**

Option A - Utiliser l'extension Firebase :
```bash
firebase ext:install firebase/storage-resize-images
```

Option B - Buildpack personnalisé :
```bash
# Créer .buildpacks
echo "https://github.com/jonathanong/heroku-buildpack-ffmpeg-latest.git" > firebase/functions/.buildpacks

# Redéployer
firebase deploy --only functions -P choose-me-l1izsi
```

Option C - Utiliser une image Docker personnalisée (avancé) :
```dockerfile
# Dockerfile
FROM node:20
RUN apt-get update && apt-get install -y ffmpeg
```

---

### **Problème 2 : Timeout**

**Erreur :**
```
Function execution took 60001 ms, finished with status: 'timeout'
```

**Solution :**

Le timeout est déjà configuré à 540s dans le code. Vérifier que le plan Firebase le permet :
- **Plan Spark (gratuit) :** Max 60s
- **Plan Blaze (payant) :** Max 540s

**Passer au plan Blaze :**
```bash
firebase projects:list
# Aller sur console.firebase.google.com
# Projet > Paramètres > Utilisation et facturation > Modifier le plan
```

---

### **Problème 3 : Mémoire insuffisante**

**Erreur :**
```
Error: memory limit exceeded
```

**Solution :**

La mémoire est déjà configurée à 2GB. Si insuffisant, augmenter à 4GB :

```javascript
exports.processPerformanceVideo = functions
  .region("us-central1")
  .runWith({
    timeoutSeconds: 540,
    memory: "4GB"  // ← Augmenter ici
  })
```

---

### **Problème 4 : Permissions Storage**

**Erreur :**
```
Error: Permission denied
```

**Solution :**

Vérifier les permissions IAM :
```bash
# Donner les permissions Storage à la function
gcloud projects add-iam-policy-binding choose-me-l1izsi \
  --member="serviceAccount:choose-me-l1izsi@appspot.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"
```

---

## 💰 Coûts Estimés

### **Plan Blaze (Payant)**

**Invocations :**
- Gratuit : 2M invocations/mois
- Au-delà : $0.40 par million

**Compute Time :**
- Gratuit : 400,000 GB-secondes/mois
- Au-delà : $0.0000025 par GB-seconde

**Réseau :**
- Gratuit : 5 GB/mois
- Au-delà : $0.12 par GB

### **Estimation pour 1000 utilisateurs**

**Hypothèses :**
- 5 vidéos/utilisateur/mois = 5000 vidéos/mois
- Durée moyenne : 30 secondes
- Temps de traitement : ~60 secondes par vidéo
- Mémoire : 2GB

**Calcul :**
- Invocations : 5000 (gratuit)
- Compute : 5000 × 60s × 2GB = 600,000 GB-s (gratuit)
- Réseau : ~50 GB (5000 × 10MB) = $5.40

**Total : ~$5-10/mois**

---

## 📈 Monitoring

### **Dashboard Firebase**

1. Aller sur https://console.firebase.google.com
2. Sélectionner le projet `choose-me-l1izsi`
3. Functions → Tableau de bord
4. Voir :
   - Nombre d'invocations
   - Temps d'exécution
   - Erreurs
   - Utilisation mémoire

### **Alertes**

Configurer des alertes pour :
- Taux d'erreur > 5%
- Temps d'exécution > 300s
- Utilisation mémoire > 80%

---

## ✅ Checklist de Déploiement

- [ ] Firebase CLI installé
- [ ] Dépendances installées (`npm install`)
- [ ] FFmpeg configuré (buildpack ou extension)
- [ ] Plan Blaze activé (pour timeout > 60s)
- [ ] Functions déployées
- [ ] Logs vérifiés
- [ ] Test avec une vraie vidéo
- [ ] Monitoring configuré
- [ ] Alertes configurées

---

## 🎉 Résultat Attendu

Après déploiement, le workflow sera :

1. **Utilisateur** enregistre une vidéo (WebM)
2. **Upload** vers Storage (`performances/userId/timestamp.webm`)
3. **Trigger** automatique de `processPerformanceVideo`
4. **Transcodage** WebM → MP4
5. **Génération** du thumbnail
6. **Upload** MP4 et thumbnail
7. **Mise à jour** Firestore avec nouvelles URLs
8. **Affichage** de la vidéo MP4 (compatible Safari/iOS)

**Temps total : ~60 secondes**

L'utilisateur voit d'abord la vidéo WebM, puis automatiquement la vidéo MP4 une fois traitée.

---

## 📞 Support

En cas de problème :

1. **Vérifier les logs :**
   ```bash
   firebase functions:log -P choose-me-l1izsi
   ```

2. **Tester en local :**
   ```bash
   npm run serve
   ```

3. **Consulter la documentation :**
   - https://firebase.google.com/docs/functions
   - https://cloud.google.com/functions/docs

4. **Contacter le support Firebase :**
   - https://firebase.google.com/support

---

## 🚀 Prochaines Étapes

Après le transcodage vidéo, vous pouvez ajouter :

1. **Compression d'images** (photos de profil)
2. **Modération de contenu** (Cloud Vision API)
3. **Notifications push** (FCM)
4. **Analyse IA** (Gemini)
5. **Génération de rapports** (statistiques)

Voir `RECOMMANDATIONS_CLOUD_FUNCTIONS.md` pour plus de détails.
