# 🔧 Configuration CORS Firebase Storage

## Problème

Quand on clique sur "Télécharger", le navigateur ouvre Firebase au lieu de télécharger directement la vidéo. Cela est dû aux restrictions CORS (Cross-Origin Resource Sharing).

---

## Solution: Configurer CORS sur Firebase Storage

### **Étape 1: Installer Google Cloud SDK**

Si pas encore installé:

```bash
# macOS (avec Homebrew)
brew install google-cloud-sdk

# Ou télécharger depuis:
# https://cloud.google.com/sdk/docs/install
```

### **Étape 2: Se Connecter à Google Cloud**

```bash
gcloud auth login
```

### **Étape 3: Définir le Projet**

```bash
gcloud config set project choose-me-l1izsi
```

### **Étape 4: Appliquer la Configuration CORS**

Le fichier `firebase/storage-cors.json` a été créé avec la configuration suivante:

```json
[
  {
    "origin": ["*"],
    "method": ["GET", "HEAD"],
    "maxAgeSeconds": 3600,
    "responseHeader": ["Content-Type", "Content-Disposition"]
  }
]
```

Appliquer cette configuration:

```bash
gsutil cors set firebase/storage-cors.json gs://choose-me-l1izsi.appspot.com
```

### **Étape 5: Vérifier la Configuration**

```bash
gsutil cors get gs://choose-me-l1izsi.appspot.com
```

Vous devriez voir la configuration CORS affichée.

---

## Alternative: Configuration via Firebase Console

Si vous n'avez pas accès à `gsutil`, vous pouvez configurer CORS via la console Firebase:

### **Méthode 1: Via Google Cloud Console**

1. Aller sur: https://console.cloud.google.com/storage/browser
2. Sélectionner le projet: `choose-me-l1izsi`
3. Cliquer sur le bucket: `choose-me-l1izsi.appspot.com`
4. Onglet "Permissions"
5. Section "CORS configuration"
6. Ajouter la configuration JSON

### **Méthode 2: Via Firebase Storage Rules**

Modifier `firebase/storage.rules`:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

Puis déployer:

```bash
firebase deploy --only storage
```

---

## Test

Après avoir configuré CORS:

1. Ouvrir l'application
2. Aller sur un profil avec vidéos
3. Cliquer sur menu (⋮)
4. Cliquer sur "Télécharger"
5. ✅ La vidéo doit se télécharger directement
6. ✅ Pas d'ouverture de Firebase

---

## Vérification CORS

Pour vérifier si CORS est bien configuré:

```bash
curl -H "Origin: http://localhost:5173" \
  -H "Access-Control-Request-Method: GET" \
  -X OPTIONS \
  https://firebasestorage.googleapis.com/v0/b/choose-me-l1izsi.appspot.com/o/performances%2F...
```

Vous devriez voir dans la réponse:
```
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, HEAD
```

---

## Commandes Complètes

```bash
# 1. Installer gcloud (si nécessaire)
brew install google-cloud-sdk

# 2. Se connecter
gcloud auth login

# 3. Définir le projet
gcloud config set project choose-me-l1izsi

# 4. Appliquer CORS
gsutil cors set firebase/storage-cors.json gs://choose-me-l1izsi.appspot.com

# 5. Vérifier
gsutil cors get gs://choose-me-l1izsi.appspot.com
```

---

## Fichier CORS Créé

**Emplacement**: `firebase/storage-cors.json`

```json
[
  {
    "origin": ["*"],
    "method": ["GET", "HEAD"],
    "maxAgeSeconds": 3600,
    "responseHeader": ["Content-Type", "Content-Disposition"]
  }
]
```

**Explication**:
- `origin: ["*"]` → Autorise toutes les origines
- `method: ["GET", "HEAD"]` → Autorise GET et HEAD
- `maxAgeSeconds: 3600` → Cache la config pendant 1h
- `responseHeader` → Headers autorisés dans la réponse

---

## Sécurité

Pour plus de sécurité en production, remplacer `"*"` par vos domaines:

```json
{
  "origin": [
    "http://localhost:5173",
    "https://choose-me-l1izsi.web.app",
    "https://chooseme.app"
  ],
  "method": ["GET", "HEAD"],
  "maxAgeSeconds": 3600,
  "responseHeader": ["Content-Type", "Content-Disposition"]
}
```

---

## Dépannage

### **Problème: gsutil non trouvé**

```bash
# Ajouter au PATH
export PATH=$PATH:~/google-cloud-sdk/bin

# Ou réinstaller
brew reinstall google-cloud-sdk
```

### **Problème: Permission refusée**

```bash
# Se reconnecter
gcloud auth login

# Vérifier le projet
gcloud config get-value project
```

### **Problème: Bucket non trouvé**

```bash
# Lister les buckets
gsutil ls

# Utiliser le bon nom
gsutil cors set firebase/storage-cors.json gs://[VOTRE-BUCKET]
```

---

## Code Amélioré

Le code dans `CustomVideoPlayer.tsx` a été mis à jour pour:

1. ✅ Télécharger la vidéo en tant que Blob
2. ✅ Créer une URL locale (blob://)
3. ✅ Forcer le téléchargement avec `download` attribute
4. ✅ Afficher un indicateur de chargement
5. ✅ Afficher un message de succès
6. ✅ Fallback avec XMLHttpRequest si fetch échoue
7. ✅ Gestion des erreurs

---

## Résultat Attendu

### **Avant CORS** ❌
- Clic sur "Télécharger"
- Ouvre Firebase dans un nouvel onglet
- Utilisateur doit cliquer à nouveau pour télécharger

### **Après CORS** ✅
- Clic sur "Télécharger"
- Message: "⏳ Téléchargement en cours..."
- Téléchargement direct dans le dossier Downloads
- Message: "✅ Vidéo téléchargée !"
- Pas d'ouverture de Firebase

---

**Appliquez la configuration CORS pour un téléchargement direct ! 🚀**
