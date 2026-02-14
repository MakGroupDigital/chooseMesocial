# 🎥 Analyse Complète du Flux Vidéo - Choose Me

## 📋 Résumé Exécutif

**Statut actuel:** ✅ L'enregistrement fonctionne | ❌ L'affichage ne fonctionne pas

**Problème identifié:** Les vidéos sont bien enregistrées dans Firebase Storage et les métadonnées dans Firestore, mais elles ne s'affichent pas sur la page de profil.

---

## 🔍 Analyse du Flux d'Enregistrement

### 1. **Capture de la Vidéo** (`CreateContentPage.tsx`)

**Localisation:** `choose-me web app/features/content/CreateContentPage.tsx`

**Processus:**
```typescript
// Étape 1: Démarrage de la caméra
startCamera() → navigator.mediaDevices.getUserMedia()
  ↓
// Étape 2: Enregistrement
MediaRecorder → enregistre le flux → crée un Blob (video/webm)
  ↓
// Étape 3: Prévisualisation
URL.createObjectURL(blob) → setRecordedUrl()
```

**✅ Points positifs:**
- Utilise MediaRecorder API standard
- Gère les deux caméras (avant/arrière)
- Permet l'import de fichiers vidéo
- Crée correctement un Blob vidéo

**⚠️ Points d'attention:**
- Format: `video/webm` (peut ne pas être supporté partout)
- Pas de compression vidéo
- Pas de limite de taille

---

### 2. **Upload vers Firebase** (`performanceService.ts`)

**Localisation:** `choose-me web app/services/performanceService.ts`

**Processus détaillé:**

```typescript
uploadPerformanceVideo(userId, userName, userAvatar, videoBlob, caption, title)
  ↓
// Étape 1: Upload dans Firebase Storage
const fileName = `performances/${userId}/${Date.now()}_performance.webm`
uploadBytes(storageRef, videoBlob)
  ↓
// Étape 2: Récupération de l'URL publique
const videoUrl = await getDownloadURL(storageRef)
  ↓
// Étape 3: Sauvegarde des métadonnées dans Firestore
collection: users/{userId}/performances
{
  videoUrl: string,
  caption: string,
  title: string,
  createdAt: serverTimestamp(),
  likes: 0,
  comments: 0,
  shares: 0,
  userName: string,
  userAvatar: string,
  userId: string
}
```

**Structure Firebase:**
```
Firebase Storage:
└── performances/
    └── {userId}/
        └── {timestamp}_performance.webm

Firestore:
└── users/
    └── {userId}/
        └── performances/ (sous-collection)
            └── {docId}
                ├── videoUrl
                ├── caption
                ├── title
                ├── createdAt
                ├── likes
                ├── comments
                ├── shares
                ├── userName
                ├── userAvatar
                └── userId
```

**✅ Logs de confirmation:**
```
📤 Début upload performance video
  - User ID: xxx
  - User Name: xxx
  - Blob size: xxx bytes
  - Storage path: performances/xxx/xxx_performance.webm
  - Uploading to Storage...
  ✓ Video uploaded to Storage
  - Download URL: https://...
  - Saving metadata to Firestore...
  - Collection path: users/xxx/performances
  ✓ Metadata saved to Firestore
  - Document ID: xxx
📤 Upload complete!
```

**✅ Permissions Firebase:**
- Storage: `allow read, write: if true` (mode développement)
- Firestore: `allow read, write: if true` (mode développement)

---

## 🔍 Analyse du Flux d'Affichage

### 3. **Récupération des Vidéos** (`performanceService.ts`)

**Fonction utilisée:** `listenToPerformanceVideos()`

**Processus:**
```typescript
listenToPerformanceVideos(userId, callback)
  ↓
// Écoute en temps réel de la collection
onSnapshot(collection(db, 'users', userId, 'performances'))
  ↓
// Transformation des données
videos.push({
  userId,
  userName,
  userAvatar,
  videoUrl,  // ← URL de téléchargement Firebase Storage
  caption,
  title,
  createdAt,
  likes,
  comments,
  shares
})
  ↓
// Tri par date
videos.sort((a, b) => timeB - timeA)
  ↓
// Callback avec les vidéos
callback(videos)
```

**✅ Logs de confirmation:**
```
Mise en place de l'écoute des vidéos pour: xxx
Vidéos en temps réel pour xxx: X
Vidéos reçues: [...]
```

---

### 4. **Affichage sur le Profil** (`ProfileViewPage.tsx`)

**Localisation:** `choose-me web app/features/profile/ProfileViewPage.tsx`

**Processus:**
```typescript
useEffect(() => {
  const unsubscribe = listenToPerformanceVideos(user.uid, (videos) => {
    setPerformanceVideos(videos)
    setLoadingVideos(false)
  })
  return () => unsubscribe()
}, [user.uid])
```

**Rendu:**
```tsx
{performanceVideos.map((video, idx) => (
  <div key={idx}>
    <video 
      src={video.videoUrl}  // ← URL Firebase Storage
      className="..."
      poster={`https://picsum.photos/seed/${idx}/300/400`}
    />
  </div>
))}
```

---

## 🐛 Problèmes Potentiels Identifiés

### **Problème #1: CORS (Cross-Origin Resource Sharing)**

**Symptôme:** Les vidéos ne se chargent pas, erreur CORS dans la console

**Cause possible:**
- Firebase Storage n'autorise pas les requêtes depuis le domaine web
- Les URLs de téléchargement ne sont pas accessibles

**Solution:**
```bash
# Configurer CORS pour Firebase Storage
gsutil cors set cors.json gs://choose-me-l1izsi.firebasestorage.app
```

Fichier `cors.json`:
```json
[
  {
    "origin": ["*"],
    "method": ["GET", "HEAD"],
    "maxAgeSeconds": 3600
  }
]
```

---

### **Problème #2: Format Vidéo Non Supporté**

**Symptôme:** La balise `<video>` ne lit pas le fichier

**Cause possible:**
- Format `video/webm` non supporté sur Safari/iOS
- Codec non compatible

**Solution:**
- Convertir en MP4 (H.264) côté serveur
- Utiliser un service de transcodage (Firebase Extensions, Cloudinary, etc.)

---

### **Problème #3: URL Expirée ou Invalide**

**Symptôme:** URL Firebase Storage retourne 403 ou 404

**Cause possible:**
- Token d'authentification expiré
- Règles de sécurité trop restrictives
- URL mal formée

**Vérification:**
```javascript
// Tester l'URL directement
console.log('Video URL:', video.videoUrl)
fetch(video.videoUrl)
  .then(r => console.log('Status:', r.status))
  .catch(e => console.error('Erreur:', e))
```

---

### **Problème #4: Chemin Firestore Incorrect**

**Symptôme:** Aucune vidéo récupérée (array vide)

**Cause possible:**
- Le chemin de la collection ne correspond pas
- L'utilisateur n'a pas de sous-collection `performances`

**Vérification:**
```javascript
// Vérifier dans la console Firebase
// Collection: users/{userId}/performances
// Doit contenir des documents avec videoUrl
```

---

### **Problème #5: Problème de Timing/Race Condition**

**Symptôme:** Les vidéos apparaissent après un refresh

**Cause possible:**
- `serverTimestamp()` crée un délai
- Le listener ne se déclenche pas immédiatement

**Solution:**
- Ajouter un délai artificiel
- Forcer un refresh après upload

---

### **Problème #6: Balise Video HTML**

**Symptôme:** La vidéo ne s'affiche pas visuellement

**Cause possible:**
- Attributs manquants (`controls`, `playsInline`)
- CSS qui cache la vidéo
- Poster image qui masque la vidéo

**Code actuel:**
```tsx
<video 
  src={video.videoUrl}
  className="w-full h-full object-cover opacity-80"
  poster={`https://picsum.photos/seed/${idx}/300/400`}
/>
```

**⚠️ Problème identifié:** Pas d'attribut `controls` !

**Solution:**
```tsx
<video 
  src={video.videoUrl}
  className="w-full h-full object-cover"
  controls  // ← AJOUTER CECI
  playsInline
  preload="metadata"
/>
```

---

## 🎯 Plan d'Action Recommandé

### **Phase 1: Diagnostic (5 min)**

1. **Ouvrir la console du navigateur** sur la page de profil
2. **Vérifier les logs:**
   - "Mise en place de l'écoute des vidéos pour: xxx"
   - "Vidéos reçues: [...]"
   - Nombre de vidéos récupérées
3. **Vérifier les erreurs:**
   - Erreurs CORS
   - Erreurs 403/404
   - Erreurs de chargement vidéo

### **Phase 2: Vérification Firebase (5 min)**

1. **Ouvrir Firebase Console**
2. **Vérifier Storage:**
   - Aller dans Storage
   - Vérifier que le dossier `performances/{userId}/` existe
   - Vérifier qu'il contient des fichiers `.webm`
   - Cliquer sur un fichier et copier l'URL
3. **Vérifier Firestore:**
   - Aller dans Firestore
   - Naviguer vers `users/{userId}/performances`
   - Vérifier qu'il y a des documents
   - Vérifier que chaque document a un champ `videoUrl`
   - Comparer l'URL avec celle de Storage

### **Phase 3: Test Manuel (5 min)**

1. **Copier une URL de vidéo depuis Firestore**
2. **Ouvrir l'URL dans un nouvel onglet**
3. **Vérifier si la vidéo se télécharge/s'affiche**
4. **Si erreur 403:** Problème de permissions
5. **Si erreur 404:** URL incorrecte
6. **Si téléchargement OK:** Problème dans le code d'affichage

### **Phase 4: Corrections (selon diagnostic)**

#### **Si problème CORS:**
```bash
# Créer cors.json
echo '[{"origin":["*"],"method":["GET","HEAD"],"maxAgeSeconds":3600}]' > cors.json

# Appliquer
gsutil cors set cors.json gs://choose-me-l1izsi.firebasestorage.app
```

#### **Si problème d'affichage HTML:**
```tsx
// Ajouter controls et playsInline
<video 
  src={video.videoUrl}
  controls
  playsInline
  preload="metadata"
  className="w-full h-full object-cover"
/>
```

#### **Si problème de format:**
```typescript
// Changer le format d'enregistrement
const recorder = new MediaRecorder(stream, { 
  mimeType: 'video/mp4' // Au lieu de video/webm
});
```

#### **Si problème de chemin:**
```typescript
// Vérifier le chemin exact
console.log('Chemin:', `users/${userId}/performances`)
console.log('User ID:', userId)
```

---

## 📊 Checklist de Vérification

### ✅ Enregistrement
- [x] Caméra démarre correctement
- [x] MediaRecorder enregistre
- [x] Blob créé avec succès
- [x] Upload vers Storage réussit
- [x] URL de téléchargement obtenue
- [x] Métadonnées sauvegardées dans Firestore
- [x] Logs de confirmation affichés

### ❓ Affichage (À vérifier)
- [ ] Listener Firestore se déclenche
- [ ] Vidéos récupérées (array non vide)
- [ ] URLs valides et accessibles
- [ ] Balise `<video>` reçoit l'URL
- [ ] Vidéo visible à l'écran
- [ ] Contrôles de lecture fonctionnels
- [ ] Pas d'erreurs CORS
- [ ] Pas d'erreurs 403/404

---

## 🔧 Code de Débogage à Ajouter

### Dans `ProfileViewPage.tsx`:

```typescript
useEffect(() => {
  setLoadingVideos(true);
  console.log('🎬 [DEBUG] Mise en place écoute vidéos');
  console.log('🎬 [DEBUG] User ID:', user.uid);
  
  const unsubscribe = listenToPerformanceVideos(user.uid, (videos) => {
    console.log('🎬 [DEBUG] Callback déclenché');
    console.log('🎬 [DEBUG] Nombre de vidéos:', videos.length);
    console.log('🎬 [DEBUG] Vidéos complètes:', JSON.stringify(videos, null, 2));
    
    // Vérifier chaque URL
    videos.forEach((video, idx) => {
      console.log(`🎬 [DEBUG] Vidéo ${idx}:`, video.videoUrl);
      
      // Tester l'accessibilité
      fetch(video.videoUrl, { method: 'HEAD' })
        .then(r => console.log(`✅ Vidéo ${idx} accessible:`, r.status))
        .catch(e => console.error(`❌ Vidéo ${idx} erreur:`, e));
    });
    
    setPerformanceVideos(videos);
    setLoadingVideos(false);
  });

  return () => {
    console.log('🎬 [DEBUG] Arrêt écoute vidéos');
    unsubscribe();
  };
}, [user.uid]);
```

### Dans le rendu:

```tsx
{performanceVideos.map((video, idx) => {
  console.log(`🎬 [RENDER] Vidéo ${idx}:`, video.videoUrl);
  
  return (
    <div key={idx} className="...">
      <video 
        src={video.videoUrl}
        controls
        playsInline
        preload="metadata"
        onLoadStart={() => console.log(`▶️ Vidéo ${idx}: Chargement démarré`)}
        onLoadedMetadata={() => console.log(`▶️ Vidéo ${idx}: Métadonnées chargées`)}
        onCanPlay={() => console.log(`▶️ Vidéo ${idx}: Prête à jouer`)}
        onError={(e) => console.error(`❌ Vidéo ${idx}: Erreur`, e)}
        className="w-full h-full object-cover"
      />
    </div>
  );
})}
```

---

## 🎯 Conclusion

**Le flux d'enregistrement est CORRECT et COMPLET.**

**Le problème se situe probablement dans:**
1. **L'affichage HTML** (manque de `controls`)
2. **Les permissions CORS** de Firebase Storage
3. **Le format vidéo** (webm non supporté sur certains navigateurs)

**Prochaine étape:** Exécuter le diagnostic en Phase 1-3 pour identifier précisément le problème.
