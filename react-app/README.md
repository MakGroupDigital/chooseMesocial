## Choose-Me React (Migration depuis Flutter)

Ce dossier contient la nouvelle application **React + Vite + TypeScript** destinée à remplacer progressivement l’ancienne application **Flutter** tout en conservant le même backend (Firebase) et la même architecture fonctionnelle.

### Structure principale

- `src/main.tsx` : point d’entrée React (montage de l’app + `BrowserRouter`).
- `src/App.tsx` : layout global (header, navigation principale, conteneur).
- `src/router.tsx` : définition de toutes les routes de l’app, en miroir des écrans Flutter (GoRouter / FlutterFlow).
- `src/core/firebase/client.ts` : initialisation Firebase (reconfigurer avec vos vraies clés).
- `src/features/**` : réplique l’arborescence de `lib/features` côté Flutter, avec un composant React par écran.

Les noms de dossiers et de pages suivent vos widgets Flutter d’origine : par exemple :

- `lib/features/home/notifications/notification_widget.dart` → `src/features/home/notifications/NotificationsPage.tsx`
- `lib/features/live_match/matches_list/matches_list_widget.dart` → `src/features/live_match/matches_list/LiveMatchesPage.tsx`
- `lib/features/profile/view/profil_u_t_widget.dart` → `src/features/profile/view/ProfileViewPage.tsx`
- etc.

### Stratégie de migration

1. **Conserver Flutter (backup)**
   - Le projet Flutter original reste intact dans `choose_me` (et un backup complet existe à côté si besoin).
   - On peut continuer à l’utiliser en parallèle pendant la migration.

2. **Reproduire l’architecture**
   - Pour chaque écran Flutter, un composant React a été créé avec le même rôle fonctionnel (mais une UI simplifiée).
   - Les dossiers de `src/features` sont alignés avec `lib/features` pour faciliter les correspondances.

3. **Migrer écran par écran**
   - Pour chaque écran :
     - Ouvrir le widget Flutter (`*_widget.dart`) et le composant React correspondant (`*Page.tsx`).
     - Reprendre :
       - la structure d’UI (sections, listes, boutons),
       - la logique métier (appel Firestore, services, state) en s’appuyant sur `core/backend/backend.dart` et les `*_service.dart` côté Flutter comme guide.
     - Connecter les données Firebase via `firebaseDb` / `firebaseAuth` dans `core/firebase/client.ts`.

4. **Optimiser les performances**
   - Tirer parti de React + Vite (réactivité, code splitting, memoisation, etc.).
   - Centraliser la logique de données (par exemple via un state manager React) pour éviter les re-rendus inutiles.

5. **Intégration Capacitor (mobile)**
   - Depuis `react-app/` :
     - `npm install @capacitor/core @capacitor/cli`
     - `npx cap init choose_me_react com.example.chooseme`
   - Configurer Capacitor pour consommer le build Vite :
     - `npm run build` → produit `dist/`
     - pointer `webDir` de Capacitor sur `dist`.
   - Ajouter les plateformes :
     - `npx cap add ios`
     - `npx cap add android`
   - Lancer les projets natifs comme d’habitude via Xcode / Android Studio.

### Lancement en développement

```bash
cd react-app
npm install        # (déjà fait une fois)
npm run dev        # démarre Vite sur http://localhost:5173
```

Vous pouvez ensuite naviguer vers les différentes routes (par ex. `/home`, `/notifications`, `/live-match`, `/admin`, `/profile`, etc.) pour implémenter et tester chaque écran au fur et à mesure.

