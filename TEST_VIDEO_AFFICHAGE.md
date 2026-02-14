# 🧪 Guide de Test - Affichage des Vidéos

## ✅ Modifications Appliquées

### 1. **ProfileViewPage.tsx**
- ✅ Ajout de `controls` sur la balise `<video>`
- ✅ Ajout de `playsInline` pour compatibilité mobile
- ✅ Ajout de `preload="metadata"` pour optimiser le chargement
- ✅ Ajout de logs de débogage détaillés
- ✅ Ajout de gestionnaires d'événements vidéo (onLoadStart, onLoadedMetadata, onCanPlay, onError)
- ✅ Ajout de test d'accessibilité des URLs (fetch HEAD)

### 2. **ExplorerPage.tsx**
- ✅ Ajout de `preload="metadata"`

### 3. **ReportageDetailPage.tsx**
- ✅ Ajout de `preload="metadata"`

---

## 🧪 Procédure de Test

### **Étape 1: Préparer l'environnement**

1. Ouvrir le terminal dans le dossier `choose-me web app`
2. Lancer l'application:
   ```bash
   npm run dev
   ```
3. Ouvrir le navigateur à l'adresse indiquée (généralement http://localhost:5173)
4. **Ouvrir la console du navigateur** (F12 ou Cmd+Option+I sur Mac)

---

### **Étape 2: Enregistrer une vidéo de test**

1. Se connecter à l'application
2. Aller sur la page "Créer du contenu" (bouton + ou /create-content)
3. Autoriser l'accès à la caméra si demandé
4. Enregistrer une courte vidéo (5-10 secondes)
5. Ajouter une description (ex: "Test vidéo performance")
6. Cliquer sur "Publier la performance"
7. **Vérifier les logs dans la console:**
   ```
   📤 Début upload performance video
     - User ID: xxx
     - Blob size: xxx bytes
     - Storage path: performances/xxx/xxx_performance.webm
   ✓ Video uploaded to Storage
     - Download URL: https://...
   ✓ Metadata saved to Firestore
     - Document ID: xxx
   📤 Upload complete!
   ```

---

### **Étape 3: Vérifier l'affichage sur le profil**

1. Aller sur la page de profil (/profile)
2. **Vérifier les logs dans la console:**
   ```
   🎬 [DEBUG] Mise en place écoute vidéos
   🎬 [DEBUG] User ID: xxx
   🎬 [DEBUG] Callback déclenché
   🎬 [DEBUG] Nombre de vidéos: 1
   🎬 [DEBUG] Vidéos complètes: [...]
   🎬 [DEBUG] Vidéo 0: https://firebasestorage.googleapis.com/...
   ✅ Vidéo 0 accessible: 200
   ```

3. **Vérifier visuellement:**
   - [ ] La section "Performances" est visible
   - [ ] La vidéo apparaît dans la grille
   - [ ] La vidéo a des contrôles de lecture (play, pause, timeline)
   - [ ] Le poster/thumbnail s'affiche
   - [ ] La légende de la vidéo est visible en bas

4. **Tester la lecture:**
   - [ ] Cliquer sur le bouton play
   - [ ] La vidéo se lance
   - [ ] Le son fonctionne (si enregistré avec audio)
   - [ ] Les contrôles répondent (pause, volume, plein écran)

---

### **Étape 4: Vérifier les logs d'événements vidéo**

Lors du chargement de la page profil, vous devriez voir dans la console:

```
▶️ Vidéo 0: Chargement démarré
▶️ Vidéo 0: Métadonnées chargées
▶️ Vidéo 0: Prête à jouer
```

**Si vous voyez une erreur:**
```
❌ Vidéo 0: Erreur [object Event]
```

Cela indique un problème de chargement de la vidéo.

---

## 🔍 Diagnostic des Problèmes

### **Problème 1: Aucune vidéo n'apparaît**

**Logs attendus:**
```
🎬 [DEBUG] Nombre de vidéos: 0
```

**Causes possibles:**
1. La vidéo n'a pas été uploadée correctement
2. Le chemin Firestore est incorrect
3. L'utilisateur n'a pas de sous-collection `performances`

**Solution:**
1. Vérifier Firebase Console → Firestore
2. Naviguer vers `users/{userId}/performances`
3. Vérifier qu'il y a des documents
4. Vérifier que chaque document a un champ `videoUrl`

---

### **Problème 2: Vidéo ne se charge pas (erreur 403)**

**Logs attendus:**
```
❌ Vidéo 0 erreur: TypeError: Failed to fetch
```

**Causes possibles:**
1. Problème de permissions Firebase Storage
2. Problème CORS
3. URL expirée ou invalide

**Solution:**

#### A. Vérifier les permissions Storage
1. Ouvrir Firebase Console → Storage
2. Onglet "Rules"
3. Vérifier que les règles permettent la lecture:
   ```
   allow read: if true;
   ```

#### B. Configurer CORS (si nécessaire)
```bash
# Créer un fichier cors.json
cat > cors.json << 'EOF'
[
  {
    "origin": ["*"],
    "method": ["GET", "HEAD"],
    "maxAgeSeconds": 3600
  }
]
EOF

# Appliquer les règles CORS
gsutil cors set cors.json gs://choose-me-l1izsi.firebasestorage.app
```

#### C. Tester l'URL manuellement
1. Copier l'URL de la vidéo depuis les logs console
2. Ouvrir l'URL dans un nouvel onglet
3. Vérifier si la vidéo se télécharge/s'affiche

---

### **Problème 3: Vidéo ne s'affiche pas visuellement**

**Logs attendus:**
```
✅ Vidéo 0 accessible: 200
▶️ Vidéo 0: Chargement démarré
(mais rien ne s'affiche)
```

**Causes possibles:**
1. Format vidéo non supporté (webm sur Safari/iOS)
2. CSS qui cache la vidéo
3. Problème de rendu React

**Solution:**

#### A. Vérifier le format vidéo
- WebM fonctionne sur Chrome, Firefox, Edge
- WebM ne fonctionne PAS sur Safari/iOS
- Solution: Convertir en MP4 ou utiliser un service de transcodage

#### B. Vérifier dans l'inspecteur
1. Ouvrir l'inspecteur (F12)
2. Onglet "Elements"
3. Chercher la balise `<video>`
4. Vérifier que l'attribut `src` contient bien l'URL
5. Vérifier les styles CSS appliqués

---

### **Problème 4: Format WebM non supporté sur Safari**

**Symptôme:** Fonctionne sur Chrome mais pas sur Safari/iOS

**Solution temporaire:**
Tester sur Chrome/Firefox d'abord

**Solution permanente:**
Modifier `CreateContentPage.tsx` pour enregistrer en MP4:

```typescript
// Ligne 86 - Changer le format
const recorder = new MediaRecorder(stream, { 
  mimeType: 'video/mp4' // Au lieu de video/webm
});

// Ligne 93 - Changer le type de blob
const blob = new Blob(chunks, { type: 'video/mp4' });
```

**Note:** Tous les navigateurs ne supportent pas `video/mp4` pour MediaRecorder.
Solution robuste: Utiliser un service de transcodage côté serveur.

---

## 📊 Checklist de Validation

### ✅ Upload
- [ ] Caméra démarre
- [ ] Enregistrement fonctionne
- [ ] Upload réussit
- [ ] Logs de confirmation affichés
- [ ] Pas d'erreur dans la console

### ✅ Affichage
- [ ] Listener se déclenche
- [ ] Vidéos récupérées (nombre > 0)
- [ ] URLs accessibles (status 200)
- [ ] Vidéo visible à l'écran
- [ ] Contrôles de lecture présents
- [ ] Lecture fonctionne
- [ ] Pas d'erreur dans la console

### ✅ Logs de débogage
- [ ] "🎬 [DEBUG] Mise en place écoute vidéos"
- [ ] "🎬 [DEBUG] Nombre de vidéos: X"
- [ ] "✅ Vidéo X accessible: 200"
- [ ] "▶️ Vidéo X: Chargement démarré"
- [ ] "▶️ Vidéo X: Métadonnées chargées"
- [ ] "▶️ Vidéo X: Prête à jouer"

---

## 🎯 Résultats Attendus

### **Scénario de Succès**

1. **Console:**
   ```
   🎬 [DEBUG] Mise en place écoute vidéos
   🎬 [DEBUG] User ID: abc123
   🎬 [DEBUG] Callback déclenché
   🎬 [DEBUG] Nombre de vidéos: 1
   🎬 [DEBUG] Vidéos complètes: [{userId: "abc123", videoUrl: "https://...", ...}]
   🎬 [DEBUG] Vidéo 0: https://firebasestorage.googleapis.com/v0/b/choose-me-l1izsi.firebasestorage.app/o/performances%2Fabc123%2F1738012345678_performance.webm?alt=media&token=xyz
   ✅ Vidéo 0 accessible: 200
   ▶️ Vidéo 0: Chargement démarré
   ▶️ Vidéo 0: Métadonnées chargées
   ▶️ Vidéo 0: Prête à jouer
   ```

2. **Interface:**
   - Section "Performances" visible
   - Grille de vidéos (2 colonnes)
   - Chaque vidéo a:
     - Thumbnail/poster
     - Contrôles de lecture
     - Légende en bas
     - Effet hover (opacité)
   - Clic sur play → vidéo se lance

---

## 🚀 Prochaines Étapes (si tout fonctionne)

1. **Optimisation:**
   - Ajouter un système de compression vidéo
   - Implémenter le transcodage en MP4
   - Ajouter des thumbnails personnalisés

2. **Fonctionnalités:**
   - Permettre la suppression de vidéos
   - Ajouter des likes/commentaires
   - Implémenter le partage

3. **Performance:**
   - Lazy loading des vidéos
   - Pagination
   - Cache des URLs

---

## 📞 Support

Si les problèmes persistent après avoir suivi ce guide:

1. **Copier tous les logs de la console**
2. **Faire une capture d'écran de l'interface**
3. **Vérifier Firebase Console:**
   - Storage: Vérifier que les fichiers existent
   - Firestore: Vérifier que les documents existent
   - Rules: Vérifier les permissions

4. **Tester l'URL de la vidéo directement dans le navigateur**

---

## 🎉 Conclusion

Les modifications apportées devraient résoudre le problème d'affichage des vidéos. Les attributs `controls` et `playsInline` sont essentiels pour que les vidéos soient visibles et jouables.

Les logs de débogage détaillés permettront d'identifier rapidement tout problème restant.

**Bonne chance avec les tests ! 🚀**
