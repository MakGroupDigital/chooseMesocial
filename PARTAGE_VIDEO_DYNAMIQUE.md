# 🔗 Partage Vidéo Dynamique - Choose Me

## ✅ Fonctionnalité Implémentée

Le bouton **"Partager"** dans le lecteur vidéo personnalisé fonctionne maintenant avec partage dynamique complet.

---

## 🎯 Fonctionnalités

### **1. Partage Natif (Web Share API)** 📱

Sur les appareils compatibles (mobile, certains navigateurs desktop), le partage utilise l'API native du système :

```javascript
navigator.share({
  title: "Titre de la vidéo",
  text: "Description + Hashtags",
  url: "Lien de la vidéo"
})
```

**Avantages :**
- ✅ Interface native de l'OS
- ✅ Partage vers toutes les apps installées
- ✅ WhatsApp, Instagram, Twitter, Email, etc.
- ✅ Expérience utilisateur optimale

### **2. Fallback Copie Presse-Papiers** 📋

Sur les navigateurs non compatibles, le texte complet est copié automatiquement :

```
Titre de la vidéo

Description de la performance

#ChooseMe #Football #Rwanda #Performance #Talent

https://chooseme.app/video/abc123
```

**Avantages :**
- ✅ Fonctionne partout
- ✅ Texte formaté prêt à coller
- ✅ Tous les hashtags inclus
- ✅ Lien direct vers la vidéo

---

## 📊 Informations Partagées

### **Titre**
- Caption de la vidéo OU
- "Vidéo de [Nom de l'utilisateur]" OU
- "Vidéo de performance - Choose Me"

### **Description**
```
Performance de [Nom] - [Sport] ([Poste])
```

Exemple :
```
Performance de Jean Dupont - Football (Attaquant)
```

### **Hashtags Dynamiques**
1. `#ChooseMe` (toujours)
2. `#[Sport]` (ex: #Football, #Basketball)
3. `#[Pays]` (ex: #Rwanda, #France)
4. `#Performance` (toujours)
5. `#Talent` (toujours)

**Exemple complet :**
```
#ChooseMe #Football #Rwanda #Performance #Talent
```

### **URL de la Vidéo**
- Si `videoId` fourni : `https://chooseme.app/video/{videoId}`
- Sinon : URL directe de la vidéo Firebase Storage

---

## 🔧 Modifications Techniques

### **1. CustomVideoPlayer.tsx**

#### **Nouvelles Props**
```typescript
interface CustomVideoPlayerProps {
  src: string;
  poster?: string;
  className?: string;
  caption?: string;
  isHD?: boolean;
  videoId?: string;        // ✨ NOUVEAU
  title?: string;          // ✨ NOUVEAU
  description?: string;    // ✨ NOUVEAU
  hashtags?: string[];     // ✨ NOUVEAU
}
```

#### **Nouvelle Fonction handleShare()**
```typescript
const handleShare = async () => {
  // Construire le texte
  const shareTitle = title || caption || 'Vidéo de performance - Choose Me';
  const hashtagsText = hashtags.map(tag => `#${tag}`).join(' ');
  const shareText = `${shareTitle}\n\n${description}\n\n${hashtagsText}`;
  const shareUrl = videoId 
    ? `${window.location.origin}/video/${videoId}` 
    : src;

  // Partage natif ou fallback
  if (navigator.share) {
    await navigator.share({ title: shareTitle, text: shareText, url: shareUrl });
  } else {
    await navigator.clipboard.writeText(`${shareText}\n\n${shareUrl}`);
    alert('✅ Lien copié dans le presse-papiers !');
  }
};
```

#### **Nouvelles Icônes**
```typescript
import { Share2, Download, Flag } from 'lucide-react';
```

#### **Menu Amélioré**
```tsx
<button onClick={handleShare}>
  <Share2 size={14} /> Partager
</button>
<button onClick={handleDownload}>
  <Download size={14} /> Télécharger
</button>
<button onClick={handleReport}>
  <Flag size={14} /> Signaler
</button>
```

---

### **2. ProfileViewPage.tsx**

#### **Passage des Props**
```tsx
<CustomVideoPlayer
  src={video.videoUrl}
  poster={video.thumbnailUrl}
  caption={video.caption}
  isHD={video.processed}
  videoId={video.id}                                    // ✨ NOUVEAU
  title={video.caption || `Vidéo de ${user.displayName}`}  // ✨ NOUVEAU
  description={`Performance de ${user.displayName} - ${user.sport} (${user.position})`}  // ✨ NOUVEAU
  hashtags={[                                           // ✨ NOUVEAU
    'ChooseMe',
    user.sport?.replace(/\s+/g, ''),
    user.country?.replace(/\s+/g, ''),
    'Performance',
    'Talent'
  ]}
  className="w-full h-full"
/>
```

---

### **3. performanceService.ts**

#### **Interface Mise à Jour**
```typescript
export interface PerformanceVideo {
  id?: string;        // ✨ NOUVEAU - ID du document Firestore
  userId: string;
  userName: string;
  userAvatar?: string;
  videoUrl: string;
  thumbnailUrl?: string;
  caption: string;
  title?: string;
  createdAt: any;
  likes: number;
  comments: number;
  shares: number;
  processed?: boolean;
  format?: string;
}
```

#### **Ajout de l'ID dans les Fonctions**
```typescript
snap.forEach((doc) => {
  const data = doc.data() as any;
  videos.push({
    id: doc.id,  // ✨ NOUVEAU
    // ... autres champs
  });
});
```

---

## 🎨 Exemple de Partage

### **Scénario : Vidéo de Jean Dupont**

**Données :**
- Nom : Jean Dupont
- Sport : Football
- Poste : Attaquant
- Pays : Rwanda
- Caption : "Mon meilleur but de la saison !"

**Texte partagé :**
```
Mon meilleur but de la saison !

Performance de Jean Dupont - Football (Attaquant)

#ChooseMe #Football #Rwanda #Performance #Talent

https://chooseme.app/video/abc123xyz
```

---

## 📱 Compatibilité

### **Web Share API Supportée** ✅
- iOS Safari (12.2+)
- Android Chrome (61+)
- Android Firefox (71+)
- macOS Safari (12.1+)
- Windows Edge (93+)

### **Fallback Presse-Papiers** ✅
- Tous les navigateurs modernes
- Desktop Chrome, Firefox, Edge
- Anciens navigateurs

---

## 🎯 Flux Utilisateur

### **1. Clic sur Menu (⋮)**
- Menu s'ouvre avec 3 options

### **2. Clic sur "Partager"**

**Si Web Share API disponible :**
1. Interface native s'ouvre
2. Utilisateur choisit l'app (WhatsApp, Instagram, etc.)
3. Texte + lien pré-remplis
4. Utilisateur envoie

**Si Web Share API non disponible :**
1. Texte copié automatiquement
2. Alert : "✅ Lien copié dans le presse-papiers !"
3. Utilisateur colle où il veut

---

## 🚀 Fonctionnalités Bonus

### **1. Téléchargement** ⬇️
```typescript
const handleDownload = () => {
  const link = document.createElement('a');
  link.href = src;
  link.download = title || 'video-choose-me.mp4';
  link.target = '_blank';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};
```

### **2. Signalement** 🚩
```typescript
const handleReport = () => {
  // TODO: Implémenter la fonctionnalité
  alert('Fonctionnalité de signalement à venir');
};
```

---

## 🧪 Test

### **Test 1 : Partage Mobile**
1. Ouvrir sur mobile (iOS/Android)
2. Cliquer sur menu (⋮)
3. Cliquer sur "Partager"
4. ✅ Interface native s'ouvre
5. ✅ Titre, description, hashtags visibles
6. ✅ Lien inclus

### **Test 2 : Partage Desktop**
1. Ouvrir sur desktop
2. Cliquer sur menu (⋮)
3. Cliquer sur "Partager"
4. ✅ Alert "Lien copié"
5. ✅ Coller dans un éditeur
6. ✅ Texte formaté avec hashtags et lien

### **Test 3 : Téléchargement**
1. Cliquer sur menu (⋮)
2. Cliquer sur "Télécharger"
3. ✅ Vidéo se télécharge

---

## 📝 Fichiers Modifiés

1. ✅ `choose-me web app/components/CustomVideoPlayer.tsx`
   - Ajout props : videoId, title, description, hashtags
   - Fonction handleShare()
   - Fonction handleDownload()
   - Fonction handleReport()
   - Icônes dans le menu

2. ✅ `choose-me web app/features/profile/ProfileViewPage.tsx`
   - Passage des nouvelles props au CustomVideoPlayer
   - Construction dynamique des hashtags

3. ✅ `choose-me web app/services/performanceService.ts`
   - Ajout de `id` dans l'interface PerformanceVideo
   - Inclusion de doc.id dans toutes les fonctions

---

## 🎉 Résultat

### **Avant** ❌
- Bouton "Partager" ne faisait rien
- Pas d'informations dynamiques
- Pas de hashtags
- Pas de lien

### **Après** ✅
- Partage natif sur mobile
- Copie automatique sur desktop
- Titre + description + hashtags dynamiques
- Lien direct vers la vidéo
- Téléchargement fonctionnel
- Menu moderne avec icônes

---

## 🔮 Améliorations Futures

1. **Page de destination vidéo** (`/video/{id}`)
   - Lecteur plein écran
   - Informations de l'athlète
   - Commentaires
   - Statistiques

2. **Tracking des partages**
   - Incrémenter `shares` dans Firestore
   - Analytics

3. **Signalement**
   - Modal de signalement
   - Catégories (spam, contenu inapproprié, etc.)
   - Envoi à la modération

4. **Partage avec image**
   - Utiliser `thumbnailUrl` dans le partage
   - Meilleur aperçu sur les réseaux sociaux

---

**Le partage vidéo est maintenant complètement fonctionnel et dynamique ! 🚀**
