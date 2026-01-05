# Structure des Features

Cette application est organisée par domaine fonctionnel :

## 📁 Structure

```
lib/
├── core/                    # Code partagé (flutter_flow, backend, auth)
│   ├── auth/               # Authentification Firebase
│   ├── backend/            # Firestore, Storage, Schemas
│   ├── components/         # Widgets réutilisables
│   └── flutter_flow/       # Utilitaires FlutterFlow
│
├── features/               # Fonctionnalités par domaine
│   ├── admin/              # Administration (modération, config, utilisateurs)
│   ├── athletes/           # Profils athlètes (basket, tennis, cycliste, etc.)
│   ├── auth/               # Connexion, inscription, mot de passe
│   ├── chat/               # Messagerie
│   ├── clubs/              # Gestion des clubs
│   ├── content/            # Articles, publications, reportages
│   ├── home/               # Pages d'accueil
│   ├── onboarding/         # Parcours d'inscription
│   ├── payment/            # Paiements
│   ├── press/              # Espace presse/journalistes
│   ├── profile/            # Profils utilisateurs
│   ├── recruiters/         # Espace recruteurs
│   ├── search/             # Recherche de talents
│   └── settings/           # Paramètres, politique
│
├── app_state.dart          # État global de l'application
├── index.dart              # Exports des pages
└── main.dart               # Point d'entrée
```

## 🏷️ Convention de nommage

- Dossiers : `snake_case` en anglais
- Fichiers widget : `feature_name_widget.dart`
- Fichiers model : `feature_name_model.dart`
- Classes : `PascalCase`
