# 📦 Installation Google Cloud SDK - Guide Manuel

## 🎯 Objectif

Installer Google Cloud SDK pour configurer CORS sur Firebase Storage et permettre le téléchargement direct des vidéos.

---

## 📥 Méthode 1: Installation Automatique (Recommandée)

### **Étape 1: Télécharger et Installer**

Ouvrez votre Terminal et exécutez:

```bash
curl https://sdk.cloud.google.com | bash
```

### **Étape 2: Redémarrer le Terminal**

```bash
exec -l $SHELL
```

### **Étape 3: Initialiser gcloud**

```bash
gcloud init
```

Suivez les instructions:
1. Connectez-vous avec votre compte Google
2. Sélectionnez le projet: `choose-me-l1izsi`
3. Configurez la région par défaut: `us-central1`

---

## 📥 Méthode 2: Installation Manuelle

### **Étape 1: Télécharger le Package**

Allez sur: https://cloud.google.com/sdk/docs/install

Téléchargez la version pour macOS (ARM ou Intel selon votre Mac)

### **Étape 2: Extraire l'Archive**

```bash
cd ~/Downloads
tar -xzf google-cloud-sdk-*.tar.gz
```

### **Étape 3: Installer**

```bash
cd google-cloud-sdk
./install.sh
```

Répondez `Y` (oui) à toutes les questions.

### **Étape 4: Ajouter au PATH**

```bash
echo 'source ~/google-cloud-sdk/path.zsh.inc' >> ~/.zshrc
echo 'source ~/google-cloud-sdk/completion.zsh.inc' >> ~/.zshrc
```

### **Étape 5: Redémarrer le Terminal**

```bash
exec -l $SHELL
```

### **Étape 6: Vérifier l'Installation**

```bash
gcloud --version
```

Vous devriez voir:
```
Google Cloud SDK 456.0.0
...
```

---

## 🔧 Configuration CORS

Une fois Google Cloud SDK installé:

### **Étape 1: Se Connecter**

```bash
gcloud auth login
```

Une page web s'ouvrira. Connectez-vous avec votre compte Google qui a accès au projet Firebase.

### **Étape 2: Définir le Projet**

```bash
gcloud config set project choose-me-l1izsi
```

### **Étape 3: Appliquer CORS**

Depuis le dossier racine de votre projet:

```bash
cd /Users/mac/choose_me
gsutil cors set firebase/storage-cors.json gs://choose-me-l1izsi.appspot.com
```

### **Étape 4: Vérifier**

```bash
gsutil cors get gs://choose-me-l1izsi.appspot.com
```

Vous devriez voir:
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

---

## ✅ Test

Après avoir configuré CORS:

1. Ouvrir votre application Choose Me
2. Aller sur un profil avec des vidéos
3. Cliquer sur le menu (⋮) d'une vidéo
4. Cliquer sur "Télécharger"
5. ✅ La vidéo doit se télécharger directement
6. ✅ Pas d'ouverture de Firebase

---

## 🚀 Script Automatique

Vous pouvez aussi utiliser le script que j'ai créé:

```bash
cd /Users/mac/choose_me/firebase
./configure-cors.sh
```

Le script fera tout automatiquement:
- Vérifier que gcloud est installé
- Vous connecter
- Configurer le projet
- Appliquer CORS
- Vérifier la configuration

---

## 🔍 Dépannage

### **Problème: gcloud: command not found**

**Solution**: Redémarrer le terminal ou ajouter manuellement au PATH:

```bash
export PATH=$PATH:~/google-cloud-sdk/bin
```

### **Problème: Permission denied**

**Solution**: Vérifier que vous êtes connecté avec le bon compte:

```bash
gcloud auth list
```

Si le compte n'est pas le bon:

```bash
gcloud auth login
```

### **Problème: Project not found**

**Solution**: Vérifier que le projet existe:

```bash
gcloud projects list
```

Si `choose-me-l1izsi` n'apparaît pas, vérifiez que vous avez accès au projet Firebase.

### **Problème: gsutil: command not found**

**Solution**: gsutil est inclus dans Google Cloud SDK. Réinstallez:

```bash
gcloud components install gsutil
```

---

## 📝 Commandes Utiles

### **Lister les buckets**
```bash
gsutil ls
```

### **Voir la configuration CORS actuelle**
```bash
gsutil cors get gs://choose-me-l1izsi.appspot.com
```

### **Supprimer la configuration CORS**
```bash
gsutil cors set /dev/null gs://choose-me-l1izsi.appspot.com
```

### **Voir les informations du projet**
```bash
gcloud config list
```

### **Changer de projet**
```bash
gcloud config set project AUTRE-PROJET
```

---

## 🎯 Résumé Rapide

```bash
# 1. Installer Google Cloud SDK
curl https://sdk.cloud.google.com | bash

# 2. Redémarrer le terminal
exec -l $SHELL

# 3. Se connecter
gcloud auth login

# 4. Configurer le projet
gcloud config set project choose-me-l1izsi

# 5. Appliquer CORS
cd /Users/mac/choose_me
gsutil cors set firebase/storage-cors.json gs://choose-me-l1izsi.appspot.com

# 6. Vérifier
gsutil cors get gs://choose-me-l1izsi.appspot.com
```

---

## 📞 Support

Si vous rencontrez des problèmes:

1. Vérifier la documentation officielle: https://cloud.google.com/sdk/docs/install
2. Vérifier que vous avez les permissions sur le projet Firebase
3. Essayer de vous reconnecter: `gcloud auth login`
4. Vérifier le nom du bucket: `gsutil ls`

---

**Une fois CORS configuré, le téléchargement des vidéos fonctionnera directement ! 🚀**
