# 🚀 Commandes Rapides - Cloud Functions

## 📦 Installation

```bash
# Installer Firebase CLI
npm install -g firebase-tools

# Se connecter
firebase login

# Installer les dépendances
cd firebase/functions
npm install
```

---

## 🚀 Déploiement

```bash
# Déployer toutes les functions
firebase deploy --only functions -P choose-me-l1izsi

# Déployer une function spécifique
firebase deploy --only functions:processPerformanceVideo -P choose-me-l1izsi

# Déployer avec logs détaillés
firebase deploy --only functions -P choose-me-l1izsi --debug
```

---

## 📊 Monitoring

```bash
# Voir tous les logs
firebase functions:log -P choose-me-l1izsi

# Logs en temps réel
firebase functions:log -P choose-me-l1izsi --follow

# Logs d'une function spécifique
firebase functions:log -P choose-me-l1izsi --only processPerformanceVideo

# Logs avec filtre
firebase functions:log -P choose-me-l1izsi --only processPerformanceVideo --follow
```

---

## 🧪 Test Local

```bash
# Démarrer l'émulateur
cd firebase/functions
npm run serve

# Ou avec tous les services
firebase emulators:start --only functions,storage,firestore
```

---

## 📋 Informations

```bash
# Lister les functions déployées
firebase functions:list -P choose-me-l1izsi

# Voir les détails d'une function
firebase functions:config:get -P choose-me-l1izsi

# Voir l'utilisation
firebase projects:list
```

---

## 🗑️ Suppression

```bash
# Supprimer une function
firebase functions:delete processPerformanceVideo -P choose-me-l1izsi

# Supprimer toutes les functions
firebase functions:delete --force -P choose-me-l1izsi
```

---

## 🔧 Dépannage

```bash
# Vérifier la configuration
firebase functions:config:get -P choose-me-l1izsi

# Tester une function localement
firebase functions:shell -P choose-me-l1izsi

# Voir les erreurs récentes
firebase functions:log -P choose-me-l1izsi --only processPerformanceVideo | grep "Error"
```

---

## 📈 Statistiques

```bash
# Voir l'utilisation
firebase projects:list

# Dashboard web
open https://console.firebase.google.com/project/choose-me-l1izsi/functions
```

---

## 🎯 Workflow Complet

```bash
# 1. Développement
cd firebase/functions
npm run serve

# 2. Test
# Uploader une vidéo via l'émulateur

# 3. Déploiement
firebase deploy --only functions -P choose-me-l1izsi

# 4. Monitoring
firebase functions:log -P choose-me-l1izsi --follow

# 5. Vérification
firebase functions:list -P choose-me-l1izsi
```

---

## 🚀 Script Automatique

```bash
# Tout en une commande
cd firebase/functions && chmod +x QUICK_START.sh && ./QUICK_START.sh
```
