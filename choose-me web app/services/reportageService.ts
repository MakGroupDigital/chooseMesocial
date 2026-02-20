import { addDoc, collection, doc, getDoc, getDocs, increment, orderBy, query, serverTimestamp, updateDoc } from 'firebase/firestore';
import { getDownloadURL, getStorage, ref, uploadBytes } from 'firebase/storage';
import { getFirebaseApp, getFirestoreDb } from './firebase';
import type { PostComment } from '../types';

export const PRESS_ARTICLE_CATEGORIES = [
  'Actualité générale',
  'Reportage',
  'Interview',
  'Joueurs',
  'Clubs',
  'Sélections nationales',
  'Transferts',
  'CAN',
  'Coupe du Monde',
  'Ligue des Champions',
  'Ligue Europa',
  'Championnat national',
  'Analyse tactique',
  'Statistiques',
  'Formation',
  'Infrastructures',
  'Business du sport',
  'Événements',
  'Blessures',
  'Arbitrage',
  'Football',
  'Basketball',
  'Tennis',
  'Volleyball',
  'Rugby',
  'Handball',
  'Athlétisme',
  'Natation',
  'Boxe',
  'MMA',
  'Lutte',
  'Judo',
  'Karaté',
  'Taekwondo',
  'Cyclisme',
  'eSport',
  'Autres sports'
] as const;
export type PressArticleCategory = typeof PRESS_ARTICLE_CATEGORIES[number];

export interface PressMediaItem {
  type: 'video' | 'photo';
  url: string;
}

export interface ReportageItem {
  id: string;
  title: string;
  detail: string;
  videoUrl: string;
  photoUrl: string;
  mediaType: 'video' | 'photo';
  mediaUrl: string;
  medias: PressMediaItem[];
  reporter: string;
  reporterAvatar?: string;
  pressWebsite?: string;
  date: string;
  likes: number;
  comments: number;
  shares: number;
  views: number;
  authorUserId?: string;
  category?: PressArticleCategory;
}

export interface CreatePressReportageInput {
  userId: string;
  category: PressArticleCategory;
  title: string;
  detail: string;
  mediaFiles?: File[];
  externalMediaUrls?: string[];
}

// Récupère les reportages depuis la collection racine "reportage"
export async function fetchReportages(): Promise<ReportageItem[]> {
  const db = getFirestoreDb();
  try {
    const ref = collection(db, 'reportage');
    const q = query(ref, orderBy('date', 'desc'));
    const snap = await getDocs(q);

    if (snap.empty) return [];

    const items: ReportageItem[] = [];
    const pressIdentityCache = new Map<string, { pressName: string; website: string; avatarUrl: string }>();

    for (const docSnap of snap.docs) {
      const data = docSnap.data() as any;
      const videoUrl =
        (data.video as string | undefined)?.trim() ||
        (data.videoUrl as string | undefined)?.trim() ||
        '';
      const photoUrl =
        (data.photo as string | undefined)?.trim() ||
        (data.image as string | undefined)?.trim() ||
        (data.imageUrl as string | undefined)?.trim() ||
        (data.photoUrl as string | undefined)?.trim() ||
        '';

      const medias: PressMediaItem[] = Array.isArray(data.medias)
        ? data.medias
            .map((media: any) => ({
              type: media?.type === 'photo' ? 'photo' : 'video',
              url: String(media?.url || '').trim()
            }))
            .filter((media: PressMediaItem) => Boolean(media.url))
        : [];

      if (medias.length === 0) {
        if (videoUrl) medias.push({ type: 'video', url: videoUrl });
        if (photoUrl) medias.push({ type: 'photo', url: photoUrl });
      }
      if (medias.length === 0) return;

      const dateStr =
        data.date && data.date.toDate
          ? data.date.toDate().toLocaleDateString()
          : '';

      const userRef = data.user_ref;
      const authorUserId =
        userRef?.id ||
        (typeof userRef?.path === 'string' ? String(userRef.path).split('/').pop() : undefined) ||
        data.userId ||
        data.user_id ||
        data.uid;

      const mainMedia = medias[0];

      const fallbackReporter = data.reporteur || data.pressName || 'Presse';
      let resolvedReporter = String(fallbackReporter);
      let resolvedWebsite = String(data.pressWebsite || data.website || '');
      let resolvedAvatar = String(data.reporterAvatar || data.authorAvatar || '');

      if (authorUserId) {
        if (!pressIdentityCache.has(authorUserId)) {
          pressIdentityCache.set(authorUserId, await resolvePressIdentity(authorUserId));
        }
        const identity = pressIdentityCache.get(authorUserId)!;
        resolvedReporter = identity.pressName || resolvedReporter;
        resolvedWebsite = identity.website || resolvedWebsite;
        resolvedAvatar = identity.avatarUrl || resolvedAvatar;
      }

      items.push({
        id: docSnap.id,
        title: data.titre || 'Article',
        detail: data.detail || '',
        videoUrl,
        photoUrl,
        mediaType: mainMedia.type,
        mediaUrl: mainMedia.url,
        medias,
        reporter: resolvedReporter,
        reporterAvatar: resolvedAvatar,
        pressWebsite: resolvedWebsite,
        date: dateStr,
        likes: Number(data.likes || 0),
        comments: Number(data.comments || 0),
        shares: Number(data.shares || 0),
        views: Number(data.views || 0),
        authorUserId,
        category: data.category
      });
    }

    return items;
  } catch (e) {
    console.error('Erreur chargement reportages Firestore:', e);
    return [];
  }
}

export async function fetchPressArticlesByUser(userId: string): Promise<ReportageItem[]> {
  const all = await fetchReportages();
  return all.filter((item) => item.authorUserId === userId);
}

async function uploadReportageMedia(userId: string, file: File, folder: 'video' | 'photo'): Promise<string> {
  const storage = getStorage(getFirebaseApp());
  const safeName = file.name.replace(/\s+/g, '_');
  const path = `reportage/${userId}/${folder}/${Date.now()}_${safeName}`;
  const storageRef = ref(storage, path);
  await uploadBytes(storageRef, file, { contentType: file.type || 'application/octet-stream' });
  return getDownloadURL(storageRef);
}

const inferMediaTypeFromUrl = (url: string): 'video' | 'photo' => {
  const clean = url.toLowerCase().split('?')[0];
  if (/\.(png|jpe?g|webp|gif|bmp|svg)$/.test(clean)) return 'photo';
  return 'video';
};

async function resolvePressIdentity(userId: string): Promise<{
  pressName: string;
  website: string;
  avatarUrl: string;
}> {
  const db = getFirestoreDb();
  const usersSnap = await getDoc(doc(db, 'users', userId));
  const legacySnap = await getDoc(doc(db, 'user', userId));
  const data = usersSnap.exists() ? usersSnap.data() : legacySnap.data();
  const pressProfile = data?.pressProfile || {};

  const pressName =
    pressProfile.mediaName ||
    pressProfile.channelName ||
    pressProfile.agencyName ||
    data?.pressName ||
    data?.displayName ||
    data?.display_name ||
    data?.userName ||
    data?.username ||
    data?.nom ||
    'Presse';

  return {
    pressName: String(pressName),
    website: String(data?.website || pressProfile.website || ''),
    avatarUrl: String(data?.avatarUrl || data?.photoUrl || data?.photo_url || '')
  };
}

export async function createPressReportage(input: CreatePressReportageInput): Promise<string> {
  const db = getFirestoreDb();
  const title = input.title.trim();
  const detail = input.detail.trim();
  const files = Array.isArray(input.mediaFiles) ? input.mediaFiles : [];
  const externalUrls = (Array.isArray(input.externalMediaUrls) ? input.externalMediaUrls : [])
    .map((url) => String(url || '').trim())
    .filter(Boolean);

  if (!title) throw new Error('Le titre est requis.');
  if (!detail) throw new Error('Le contenu est requis.');
  if (files.length === 0 && externalUrls.length === 0) {
    throw new Error('Ajoutez au moins un média (photo ou vidéo).');
  }

  const medias: PressMediaItem[] = [];

  for (const file of files) {
    const type: 'video' | 'photo' = file.type.startsWith('image/') ? 'photo' : 'video';
    const url = await uploadReportageMedia(input.userId, file, type);
    medias.push({ type, url });
  }

  for (const url of externalUrls) {
    medias.push({ type: inferMediaTypeFromUrl(url), url });
  }

  const { pressName, website, avatarUrl } = await resolvePressIdentity(input.userId);
  const firstVideo = medias.find((media) => media.type === 'video')?.url || null;
  const firstPhoto = medias.find((media) => media.type === 'photo')?.url || null;

  const refDoc = await addDoc(collection(db, 'reportage'), {
    titre: title,
    detail,
    medias,
    mediaCount: medias.length,
    video: firstVideo,
    photo: firstPhoto,
    reporteur: pressName,
    pressName,
    pressWebsite: website || null,
    reporterAvatar: avatarUrl || null,
    likes: 0,
    comments: 0,
    shares: 0,
    views: 0,
    category: input.category,
    user_ref: doc(db, 'users', input.userId),
    userId: input.userId,
    date: serverTimestamp(),
    createdAt: serverTimestamp()
  });

  return refDoc.id;
}

export type ReportageMetric = 'likes' | 'comments' | 'shares' | 'views';

export async function updateReportageMetric(
  reportageId: string,
  metric: ReportageMetric,
  amount: number
): Promise<void> {
  if (!reportageId || amount === 0) return;
  const db = getFirestoreDb();
  await updateDoc(doc(db, 'reportage', reportageId), {
    [metric]: increment(amount)
  });
}

export async function addReportageComment(
  reportageId: string,
  input: {
    userId: string;
    userName: string;
    userAvatar?: string;
    text: string;
  }
): Promise<void> {
  const db = getFirestoreDb();
  const text = input.text.trim();
  if (!reportageId || !text) return;

  await addDoc(collection(db, 'reportage', reportageId, 'comments'), {
    userId: input.userId,
    userName: input.userName || 'Utilisateur',
    userAvatar: input.userAvatar || '',
    text,
    createdAt: serverTimestamp()
  });
}

export async function fetchReportageComments(reportageId: string): Promise<PostComment[]> {
  const db = getFirestoreDb();
  const commentsCol = collection(db, 'reportage', reportageId, 'comments');
  const q = query(commentsCol, orderBy('createdAt', 'asc'));
  const snap = await getDocs(q);

  return snap.docs.map((d) => {
    const data = d.data() as any;
    const createdAt =
      data.createdAt && data.createdAt.toDate
        ? data.createdAt.toDate().toLocaleString()
        : '';

    return {
      id: d.id,
      userId: data.userId || '',
      userName: data.userName || 'Utilisateur',
      userAvatar: data.userAvatar || undefined,
      text: data.text || '',
      createdAt,
      likes: typeof data.likes === 'number' ? data.likes : 0
    };
  });
}
