# Règles Firebase - Mode Développement

## ⚠️ IMPORTANT - DÉVELOPPEMENT UNIQUEMENT

Les règles actuelles sont **PERMISSIVES** et permettent **TOUT** pour faciliter le développement.

### Fichiers modifiés :

1. **storage.rules** - Permet la lecture/écriture complète
2. **firestore.rules** - Permet la lecture/écriture complète

### Déploiement

Les règles ont été déployées avec Firebase CLI :

```bash
firebase deploy --only storage -P choose-me-l1izsi
firebase deploy --only firestore:rules -P choose-me-l1izsi
```

### ⚠️ AVANT LA PRODUCTION

Avant de déployer en production, vous DEVEZ :

1. **Mettre à jour storage.rules** avec des règles sécurisées :
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profiles/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    match /public/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

2. **Mettre à jour firestore.rules** avec des règles sécurisées basées sur votre modèle de données

3. **Activer l'authentification** pour les utilisateurs

4. **Tester les règles** avant le déploiement en production

### Commandes utiles

```bash
# Vérifier les règles actuelles
firebase rules:list --project choose-me-l1izsi

# Déployer uniquement les règles Storage
firebase deploy --only storage -P choose-me-l1izsi

# Déployer uniquement les règles Firestore
firebase deploy --only firestore:rules -P choose-me-l1izsi

# Déployer tout
firebase deploy -P choose-me-l1izsi
```

### Statut actuel

✅ **Storage** - Permissif (développement)
✅ **Firestore** - Permissif (développement)
✅ **Authentication** - Activée (Firebase Auth)
