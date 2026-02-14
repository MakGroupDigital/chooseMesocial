# 🔥 Firebase Cloud Functions - Choose Me

## 📋 Fonctions Disponibles

### 1. **processPerformanceVideo** 🎬
**Trigger :** Storage (upload de fichier)  
**Région :** us-central1  
**Mémoire :** 2GB  
**Timeout :** 540s (9 minutes)

**Description :**
Transcoder automatiquement les vidéos de performance de WebM vers MP4 et générer des thumbnails.

**Workflow :**
1. Détecte l'upload d'une vidéo dans `performances/`
2. Télécharge la vidéo
3. Transcoder en MP4 (H.264, AAC)
4. Génère un thumbnail (JPG, 540x960)
5. Upload MP4 et thumbnail
6. Met à jour Firestore avec les nouvelles URLs

**Avantages :**
- ✅ Compatibilité universelle (MP4 fonctionne sur Safari/iOS)
- ✅ Meilleure compression (vidéos plus légères)
- ✅ Thumbnails automatiques
- ✅ Traitement transparent pour l'utilisateur

---

### 2. **onUserDeleted** 🗑️
**Trigger :** Auth (suppression d'utilisateur)  
**Région :** us-central1

**Description :**
Nettoie automatiquement toutes les données d'un utilisateur supprimé.

**Actions :**
1. Supprime le document Firestore `users/{userId}`
2. Supprime toutes les vidéos dans `performances/{userId}/`
3. Supprime les sous-collections (followers, performances, etc.)

---

### 3. **notifyNewFollower** 👥
**Trigger :** Firestore (création de document)  
**Région :** us-central1

**Description :**
Envoie une notification push quand quelqu'un suit un utilisateur.

**Workflow :**
1. Détecte la création d'un document dans `users/{userId}/followers/{followerId}`
2. Récupère le nom du follower
3. Récupère le token FCM de l'utilisateur
4. Envoie une notification push

---

## 🚀 Installation

### 1. Installer les dépendances

```bash
cd firebase/functions
npm install
```

### 2. Configurer FFmpeg

**Option A - Buildpack (recommandé) :**
```bash
echo "https://github.com/jonathanong/heroku-buildpack-ffmpeg-latest.git" > .buildpacks
```

**Option B - Extension Firebase :**
```bash
firebase ext:install firebase/storage-resize-images
```

### 3. Déployer

```bash
# Toutes les functions
firebase deploy --only functions -P choose-me-l1izsi

# Une function spécifique
firebase deploy --only functions:processPerformanceVideo -P choose-me-l1izsi
```

---

## 🧪 Test en Local

```bash
# Démarrer l'émulateur
npm run serve

# Dans un autre terminal, tester
firebase emulators:start --only functions,storage,firestore
```

---

## 📊 Monitoring

### Voir les logs

```bash
# Tous les logs
firebase functions:log -P choose-me-l1izsi

# Logs d'une function spécifique
firebase functions:log -P choose-me-l1izsi --only processPerformanceVideo

# Logs en temps réel
firebase functions:log -P choose-me-l1izsi --follow
```

### Dashboard

https://console.firebase.google.com/project/choose-me-l1izsi/functions

---

## 💰 Coûts

**Plan Blaze requis** (pour timeout > 60s)

**Gratuit jusqu'à :**
- 2M invocations/mois
- 400,000 GB-secondes/mois
- 5 GB réseau/mois

**Estimation pour 1000 utilisateurs :**
- ~5000 vidéos/mois
- ~$5-10/mois

---

## 🐛 Dépannage

### FFmpeg non trouvé
```bash
# Vérifier l'installation
firebase functions:shell
> const { spawn } = require('child-process-promise');
> spawn('ffmpeg', ['-version'])
```

### Timeout
- Vérifier que le plan Blaze est activé
- Augmenter le timeout dans le code (max 540s)

### Mémoire insuffisante
- Augmenter la mémoire à 4GB dans le code

---

## 📚 Documentation

- [Firebase Functions](https://firebase.google.com/docs/functions)
- [Cloud Storage Triggers](https://firebase.google.com/docs/functions/gcp-storage-events)
- [FFmpeg Documentation](https://ffmpeg.org/documentation.html)

---

## 🎯 Prochaines Étapes

1. ✅ Transcodage vidéo (implémenté)
2. ⏳ Compression d'images
3. ⏳ Modération de contenu
4. ⏳ Notifications push avancées
5. ⏳ Analyse IA avec Gemini

Voir `DEPLOYMENT_GUIDE.md` pour les instructions détaillées.
