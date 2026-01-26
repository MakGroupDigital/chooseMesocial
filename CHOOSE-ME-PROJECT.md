## CHOOSE-ME PROJECT

### 1. Vision générale

**Choose-Me** est un réseau social sportif dédié aux talents africains (joueurs), aux recruteurs, clubs et presse.  
L’objectif est de :
- permettre aux **athlètes** de créer un profil riche (statistiques, vidéos, photos),
- donner aux **recruteurs / clubs** des outils de recherche et d’évaluation,
- offrir à la **presse** un espace de contenus (articles, reportages),
- ajouter des fonctionnalités ludiques comme les **pronostics en live** avec portefeuille et récompenses.

L’application existe aujourd’hui sous deux formes :
- une **ancienne app Flutter** (multiplateforme mobile + web),
- une **nouvelle app React + Vite** (web), pensée pour être ensuite emballée avec **Capacitor** pour mobile.

La version Flutter est conservée (et sauvegardée) pour référence et éventuel retour en arrière.

---

### 2. Architecture globale

#### 2.1. Back-end & données

- **Firebase** (projet existant, partagé entre Flutter et React) :
  - `Firebase Auth` : gestion des comptes utilisateurs, connexion email/mot de passe, Google, Apple.
  - `Cloud Firestore` : collections principales :
    - `users` : profil de base utilisateur (email, displayName, type, pays, statut, etc.).
    - `matches` : matchs pour la fonctionnalité Live Match (statut, scores, récompenses).
    - `pronostics` : pronostics des utilisateurs sur les matchs.
    - `wallets` : portefeuille associé à chaque utilisateur (solde, points).
    - `transactions` : historique des crédits/débits du portefeuille.
    - `withdrawals` : demandes de retrait.
    - `articles`, `publications`, `reportages` : contenus éditoriaux / médias.
    - `audit_logs` : logs d’actions importantes (sécurité, audits).
  - `Firebase Storage` : stockage de médias (photos de profils, vidéos, etc.).
  - `Firebase Functions` (si utilisé) : logique back-end complémentaire (non détaillée ici).

#### 2.2. Ancien front Flutter

- Organisation principale dans `lib/` :
  - `lib/core` : auth Firebase (`auth_util`), backend Firestore (`backend.dart`), thème FlutterFlow, widgets de base.
  - `lib/features` : un dossier par **feature métier** (onboarding, auth, home, live_match, profile, admin, etc.).
  - `lib/main.dart` : configuration globale, `GoRouter`, injection du thème et de l’état global (`FFAppState`).
- Patterns :
  - Chaque écran est un `*Widget` + un `*Model` associé (pattern FlutterFlow).
  - Navigation via **GoRouter** et noms de routes statiques dans les widgets.
  - Beaucoup de logique Firestore encapsulée dans `backend.dart` et des services spécialisés (`pronostic_service.dart`, `wallet_service.dart`, `leaderboard_service.dart`, `football_api_service.dart`).

#### 2.3. Nouveau front React + Vite

Le nouveau front se trouve dans `react-app/` :

- **Stack** :
  - `React 18` + `TypeScript`.
  - `Vite` pour le bundling/dev server (très rapide).
  - `react-router-dom` pour la navigation.
  - `firebase` (SDK JS) pour Auth, Firestore, Storage.

- **Structure de dossiers** (`react-app/src`) :
  - `main.tsx` : point d’entrée React, montage sur `#root`, `BrowserRouter`.
  - `App.tsx` : layout global (header, navigation simple, zone de contenu).
  - `router.tsx` : **toutes les routes** de l’app, alignées sur la structure Flutter (`/onboarding`, `/login`, `/home`, `/live-match`, `/profile`, `/admin`, etc.).
  - `core/firebase/client.ts` :
    - initialise `firebaseApp`,
    - expose `firebaseAuth`, `firebaseDb`, `firebaseStorage`.
  - `features/` :
    - reflète 1:1 `lib/features` Flutter :
      - `auth/login/LoginPage.tsx`
      - `onboarding/modern_onboarding/ModernOnboardingPage.tsx`
      - `onboarding/create_account/OnboardingCreateAccountPage.tsx`
      - `onboarding/choose_type/OnboardingChooseTypePage.tsx`
      - `onboarding/player_info/OnboardingPlayerInfoPage.tsx`
      - `home/main/HomeChoosePage.tsx`
      - `home/notifications/NotificationsPage.tsx`
      - `live_match/...` : `LiveMatchesPage`, `MatchDetailPage`, `LeaderboardPage`, `WalletPage`, `WithdrawalPage`.
      - `profile/...` : `ProfileViewPage`, `ProfileEditPage`, `ProfileTalentPage`, etc.
      - `admin/...`, `clubs/...`, `press/...`, `recruiters/...`, `content/...`, `settings/...`, `common/...`.
    - chaque `*Page.tsx` reprend le **rôle fonctionnel** du widget Flutter équivalent.

---

### 3. Modules fonctionnels principaux

#### 3.1. Onboarding

Flux utilisateur :
1. **Modern Onboarding** (`ModernOnboardingPage.tsx` / `ModernOnboardingWidget` Flutter) :
   - 3 écrans avec images plein écran (basket, foot, visuels ChooseMe),
   - messages marketing : découverte de talent, connexion aux recruteurs, réalisation de carrière,
   - boutons : `Connexion` (→ `/login`), `Suivant` / `Commencer` (→ `/onboarding/create-account`).
2. **Choix du type d’utilisateur** (`ChoisirtypeWidget` Flutter, `OnboardingChooseTypePage.tsx` React) :
   - types : `athlete`, `recruteur`, `club`, `presse`, `visiteur`.
   - impact sur la suite du flow et sur les droits dans l’app.
3. **Création de compte** (`CreatWidget` Flutter, `OnboardingCreateAccountPage.tsx` React) :
   - email, mot de passe, confirmation, téléphone, pays, type, acceptation des CGU.
   - dans Flutter : création du compte Firebase Auth + enregistrement Firestore (`UserRecord`), initialisation de `statut` / `etat` et redirection selon le type.
4. **Complétion des infos joueur** (`CompleteinfosjouereWidget` Flutter, `OnboardingPlayerInfoPage.tsx` React) :
   - choix du sport, position, taille, poids, etc.

Dans React, le squelette de ces pages est déjà présent, et l’onboarding principal moderne est entièrement conçu (`ModernOnboardingPage.tsx`).

#### 3.2. Authentification

- **Connexion** (`ConnexionWidget` Flutter, `LoginPage.tsx` React) :
  - Flutter :
    - formulaire email + mot de passe,
    - intégration `authManager.signInWithEmail` + Google + Apple,
    - redirection vers écran de chargement puis dashboard (`Home8Widget`).
  - React :
    - `LoginPage.tsx` :
      - UI sombre + background image (même image que Flutter),
      - logo rond ChooseMe (`Sans_titre-2_(4).png`),
      - `signInWithEmailAndPassword` (Firebase JS) sur le même projet,
      - redirection vers `/home` en cas de succès,
      - liens vers `/password-reset` et `/onboarding/create-account`.

#### 3.3. Live Match, Pronostics & Portefeuille

Composants majeurs :

- `footballApiService` (Dart) / `footballApiService.ts` (React) :
  - récupère les matchs du jour (API Football-Data ou Firestore),
  - gère les données de test si l’API est indisponible (Real Madrid vs Barça, etc.),
  - standardise le modèle `MatchData` (id, équipes, logos, scores, statut, minute, etc.).

- `MatchesListWidget` / `LiveMatchesPage.tsx` :
  - affiche la liste des matchs :
    - **À venir** (scheduled),
    - **En cours** (live),
    - **Terminés** (finished),
  - montre le statut (en live, programmé, etc.), les scores, et permet d’ouvrir le détail d’un match (`/live-match/:id`).

- `PronosticService` (Dart) / `pronosticService.ts` (React) :
  - sauvegarde les pronostics de l’utilisateur dans `pronostics`,
  - limite le nombre de pronostics par minute (rate limiting),
  - empêche les pronostics après le début du match ou quand le match n’est plus `scheduled`,
  - fournit des stats (répartition team_a/draw/team_b).

- `MatchDetailWidget` / `MatchDetailPage.tsx` :
  - affiche le détail d’un match (équipes, score, minute, statut),
  - permet à l’utilisateur de faire un pronostic (`team_a`, `draw`, `team_b`),
  - montre la répartition des pronostics (stats) pour ce match.

- `WalletService` / `walletService.ts` :
  - gère le portefeuille utilisateur :
    - lecture/création de `wallets`,
    - ajout de récompenses (`addReward`) après un pronostic gagné,
    - création de transactions dans `transactions`,
    - demandes de retrait dans `withdrawals` (validation des montants, état `pending`).

- `LeaderboardService` / `leaderboardService.ts` :
  - calcule le **classement global** et par match,
  - agrège les pronostics gagnants, calcule nombre de victoires, taux de réussite, gains estimés,
  - renvoie des `LeaderboardEntry` (rank, userName, stats).

- Pages React correspondantes :
  - `LiveMatchesPage.tsx` : liste des matchs avec sections et navigation,
  - `MatchDetailPage.tsx` : détail du match + UI de pronostic + stats,
  - `LeaderboardPage.tsx` : tableau de classement mensuel,
  - `WalletPage.tsx` : vue portefeuille (solde, points, gains mensuels, retraits en attente),
  - `WithdrawalPage.tsx` : formulaire de retrait (montant, méthode, téléphone).

#### 3.4. Profils, recherche, contenu, admin…

Ces modules sont structurés 1:1 entre Flutter et React et contiennent :

- **Profils** :
  - vue profil utilisateur (`profile/view`),
  - édition de profil (`profile/edit`),
  - profil talent (`profile/talent`).
- **Recherche de talents** :
  - filtres, critères sportifs, affichage de cartes de joueurs.
- **Contenus** :
  - création d’articles, publications, reportages,
  - vue détaillée, listes (home reportages), écrans de succès après publication.
- **Admin / dashboards** :
  - gestion des utilisateurs (athlètes, clubs, recruteurs, presse),
  - modération, publications, configuration avancée,
  - dashboards dédiés pour clubs, presse, recruteurs.

---

### 4. Charte graphique (web React)

L’UI React s’inspire fortement de la version Flutter, avec quelques contraintes du web :

- **Palette** :
  - Fond global : `#050505` / `#0A0A0A` (noir / gris très foncé).
  - Vert principal : `#208050` (PRIMARY_GREEN).
  - Vert secondaire : `#19DB8A` (SECONDARY_GREEN).
  - Orange accent : `#FF8A3C` (ACCENT_ORANGE) — utilisé à ~10% maximum, pour les badges ou bordures.

- **Règles** :
  - **Pas de dégradés multicolores** sur les surfaces principales quand tu ne le souhaites pas : on utilise des aplats (fond noir, blocs gris foncé, boutons verts unis).
  - Les ombres (`box-shadow`) servent à donner de la profondeur sans casser la lisibilité.
  - Les cartes principales (onboarding, login, wallet, live match) ont des bords arrondis (16–28px) et des bordures semi‑transparentes.

- **Typographie** :
  - Inspirée de Inter / Readex Pro (comme Flutter).
  - Titres en gras, texte secondaire en petite taille avec haute lisibilité.

- **Iconographie** :
  - **Logo** : `Sans_titre-4.png` et `Sans_titre-2_(4).png` importés depuis `assets/images` et utilisés dans les headers / avatars.
  - Icônes : plutôt vectorielles / texte que des stickers (par ex. petits tags “TALENT”, “RECRUTEUR” dans l’onboarding au lieu d’emojis).

---

### 5. Notes pour développeurs

#### 5.1. Lancer l’app React

```bash
cd react-app
npm install      # une seule fois
npm run dev      # démarre Vite sur http://localhost:5173
```

Endpoints intéressants :
- `/onboarding` : onboarding moderne complet.
- `/login` : page de connexion (Firebase email/mot de passe).
- `/onboarding/create-account`, `/onboarding/type`, `/onboarding/player-info` : autres étapes.
- `/home`, `/notifications`, `/live-match`, `/wallet`, `/admin`, etc.

#### 5.2. Brancher le vrai Firebase

Dans `src/core/firebase/client.ts` :

```ts
const firebaseConfig = {
  apiKey: '...',
  authDomain: '...',
  projectId: '...',
  storageBucket: '...',
  messagingSenderId: '...',
  appId: '...'
};
```

Utiliser la même configuration que l’app Flutter pour partager Auth et Firestore.

#### 5.3. Migration progressive Flutter → React

Stratégie recommandée :

1. **Conserver Flutter** :
   - Ne pas supprimer l’ancien projet.
   - Utiliser le dossier backup si besoin pour comparer.

2. **Migrer module par module** :
   - Onboarding + Auth → Live Match + Pronostics + Wallet → Profil → Recherche → Admin, etc.
   - Pour chaque module :
     - ouvrir le widget Flutter (`*_widget.dart`),
     - ouvrir la page React correspondante (`*Page.tsx`),
     - recopier la logique Firestore / Auth en JS (services React déjà créés pour Live Match / Pronostics / Wallet / Leaderboard),
     - adapter l’UI pour rester dans la charte (fonds unis, verts / noirs, touches d’orange).

3. **Intégrer Capacitor (mobile)** :
   - Depuis `react-app/` :
     - `npm install @capacitor/core @capacitor/cli`
     - `npx cap init choose_me_react com.example.chooseme`
   - Configurer `capacitor.config` pour pointer `webDir` vers le build Vite :
     - `npm run build` → génère `dist/`
     - `webDir: 'dist'`
   - Ajouter les plateformes :
     - `npx cap add ios`
     - `npx cap add android`
   - Lancer Xcode / Android Studio pour construire les apps natives.

---

### 6. Résumé

- **Choose-Me** est une app riche, multi‑rôles (athlètes, recruteurs, clubs, presse, visiteurs) avec des fonctions sociales et ludiques.
- L’ancien front Flutter reste la **référence fonctionnelle et visuelle**.
- Le nouveau front **React + Vite** reprend :
  - **l’architecture** (mêmes features, mêmes écrans),
  - **la logique métier** (surtout Live Match / Pronostics / Wallet déjà migrés),
  - une **charte graphique modernisée** mais fidèle (noir + verts ChooseMe + un peu d’orange).
- La migration se fait **progressivement**, en portant chaque écran Flutter vers un équivalent React connecté au même projet Firebase, puis en emballant le tout avec Capacitor pour obtenir les applis mobiles modernes.

