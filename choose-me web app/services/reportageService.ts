import {
  addDoc,
  arrayRemove,
  arrayUnion,
  collection,
  doc,
  getDocs,
  increment,
  orderBy,
  query,
  serverTimestamp,
  updateDoc
} from 'firebase/firestore';
import { getFirestoreDb } from './firebase';
import { createAppNotification } from './notificationService';

export type PressContentKind = 'article' | 'reportage';
export type PressMediaType = 'none' | 'image' | 'video';

export const PRESS_CONTENT_CATEGORIES = [
  'Sport',
  'CAN 2026',
  'Football',
  'Basketball',
  'Athlétisme',
  'Interview',
  'Reportage terrain',
  'Transferts',
  'Équipes',
  'Formation',
  'Opinion'
] as const;

export interface ReportageItem {
  id: string;
  title: string;
  detail: string;
  videoUrl: string;
  imageUrl: string;
  mediaUrl: string;
  mediaType: PressMediaType;
  kind: PressContentKind;
  reporter: string;
  reporterId: string;
  date: string;
  category: string;
  likes: number;
  likedBy: string[];
  shares: number;
  comments: number;
  thumbnailUrl?: string;
  docPath: string;
}

interface PressMediaUploadResult {
  provider: 'cloudinary';
  mediaUrl: string;
  videoUrl?: string;
  imageUrl?: string;
  secureUrl: string;
  thumbnailUrl?: string;
  publicId: string;
  resourceType: 'image' | 'video';
  format?: string;
  bytes?: number;
  duration?: number;
  width?: number;
  height?: number;
}

interface CreatePressContentInput {
  authorId: string;
  authorName: string;
  authorAvatar?: string;
  title: string;
  detail: string;
  kind: PressContentKind;
  category?: string;
  mediaFile?: File | null;
}

type PressMediaUploadPayload = PressMediaUploadResult | { error?: string; detail?: string } | null;

const countLikes = (value: unknown): number => {
  if (Array.isArray(value)) return value.length;
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  return 0;
};

const countNumber = (...values: unknown[]): number => {
  for (const value of values) {
    if (typeof value === 'number' && Number.isFinite(value)) return value;
    if (Array.isArray(value)) return value.length;
  }
  return 0;
};

const getString = (...values: unknown[]): string => {
  for (const value of values) {
    if (typeof value === 'string' && value.trim()) return value.trim();
  }
  return '';
};

const formatDate = (value: any): string => {
  if (value?.toDate) return value.toDate().toLocaleDateString();
  if (value instanceof Date) return value.toLocaleDateString();
  if (typeof value === 'string' && value.trim()) return value;
  return '';
};

const getMediaType = (data: any, videoUrl: string, imageUrl: string): PressMediaType => {
  const explicit = String(data?.mediaType || '').toLowerCase();
  if (explicit === 'video' || explicit === 'image') return explicit;
  if (videoUrl) return 'video';
  if (imageUrl) return 'image';
  return 'none';
};

const isVideoFile = (file: File): boolean =>
  file.type.startsWith('video/') || /\.(webm|mp4|mov|m4v|ogg)$/i.test(file.name);

const isImageFile = (file: File): boolean =>
  file.type.startsWith('image/') || /\.(jpg|jpeg|png|webp|gif|avif)$/i.test(file.name);

const createMediaFormData = (file: File, userId: string): FormData => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('userId', userId);
  return formData;
};

const normalizeUploadPayload = (payload: PressMediaUploadPayload): PressMediaUploadResult | null => {
  if (!payload || !('provider' in payload)) return null;

  const videoUrl = payload.videoUrl || '';
  const imageUrl = payload.imageUrl || '';
  const secureUrl = payload.secureUrl || videoUrl || imageUrl || '';
  const mediaUrl = payload.mediaUrl || videoUrl || imageUrl || secureUrl;
  const resourceType = payload.resourceType === 'video' || payload.resourceType === 'image'
    ? payload.resourceType
    : videoUrl ? 'video' : 'image';

  if (!mediaUrl) return null;

  return {
    ...payload,
    mediaUrl,
    videoUrl,
    imageUrl,
    secureUrl,
    resourceType
  };
};
const formatUploadError = (payload: PressMediaUploadPayload, fallback: string): string => {
  const detail = payload && 'detail' in payload && payload.detail ? ` (${payload.detail})` : '';
  return `${payload && 'error' in payload ? payload.error : fallback}${detail}`;
};
async function postPressMedia(endpoint: string, file: File, userId: string): Promise<{ response: Response; payload: PressMediaUploadPayload }> {
  const response = await fetch(endpoint, {
    method: 'POST',
    body: createMediaFormData(file, userId)
  });

  const payload = await response.json().catch(() => null) as PressMediaUploadPayload;
  return { response, payload };
}

async function uploadPressMedia(file: File, userId: string): Promise<PressMediaUploadResult> {
  if (!isVideoFile(file) && !isImageFile(file)) {
    throw new Error('Le média doit être une image ou une vidéo.');
  }
  const primary = await postPressMedia('/api/reportage-media', file, userId);
  const primaryPayload = normalizeUploadPayload(primary.payload);

  if (primary.response.ok && primaryPayload) {
    return primaryPayload;
  }

  if (primary.response.status !== 404) {
    throw new Error(formatUploadError(primary.payload, 'Impossible d’uploader le média sur Cloudinary.'));
  }

  const fallbackEndpoint = isVideoFile(file) ? '/api/performance-media' : '/api/profile-image';
  const fallback = await postPressMedia(fallbackEndpoint, file, userId);
  const fallbackPayload = normalizeUploadPayload(fallback.payload);

  if (!fallback.response.ok || !fallbackPayload) {
    throw new Error(formatUploadError(fallback.payload, 'Impossible d’uploader le média sur Cloudinary.'));
  }
  return fallbackPayload;
}

export async function fetchReportages(): Promise<ReportageItem[]> {
  const db = getFirestoreDb();
  try {
    const ref = collection(db, 'reportage');
    const q = query(ref, orderBy('date', 'desc'));
    const snap = await getDocs(q);

    if (snap.empty) return [];

    const items: ReportageItem[] = [];
    snap.forEach((docSnap) => {
      const data = docSnap.data() as any;
      const videoUrl = getString(data.video, data.videoUrl, data.cloudinaryUrl, data.secure_url);
      const imageUrl = getString(data.image, data.imageUrl, data.coverUrl, data.thumbnailUrl, data.photoUrl);
      const mediaType = getMediaType(data, videoUrl, imageUrl);
      const mediaUrl = mediaType === 'video' ? videoUrl : imageUrl;
      const title = getString(data.titre, data.title, 'Reportage');
      const detail = getString(data.detail, data.description, data.content);
      if (!title && !detail && !mediaUrl) return;
      const likedBy = Array.isArray(data.likes) ? data.likes.filter((id: unknown) => typeof id === 'string') : [];

      items.push({
        id: docSnap.id,
        title,
        detail,
        videoUrl,
        imageUrl,
        mediaUrl,
        mediaType,
        kind: data.kind === 'article' ? 'article' : 'reportage',
        reporter: getString(data.reporteur, data.reporter, data.authorName, 'Média Choose Me'),
        reporterId: getString(data.reporterId, data.authorId, data.userId),
        date: formatDate(data.date || data.createdAt),
        category: getString(data.category, data.categorie, 'Sport'),
        likes: countLikes(data.likes),
        likedBy,
        shares: typeof data.shares === 'number' ? data.shares : 0,
        comments: countNumber(data.num_comments, data.comments, data.commentCount, data.commentsCount),
        thumbnailUrl: getString(data.thumbnailUrl, imageUrl),
        docPath: docSnap.ref.path
      });
    });

    return items;
  } catch (e) {
    console.error('Erreur chargement reportages Firestore:', e);
    return [];
  }
}

export async function createPressContent(input: CreatePressContentInput): Promise<string> {
  const db = getFirestoreDb();
  let media: PressMediaUploadResult | null = null;

  if (input.mediaFile) {
    media = await uploadPressMedia(input.mediaFile, input.authorId);
  }

  const mediaType: PressMediaType = media?.resourceType === 'video' ? 'video' : media?.resourceType === 'image' ? 'image' : 'none';
  const docRef = await addDoc(collection(db, 'reportage'), {
    kind: input.kind,
    type: input.kind,
    titre: input.title.trim(),
    title: input.title.trim(),
    detail: input.detail.trim(),
    description: input.detail.trim(),
    category: input.category || 'Sport',
    reporteur: input.authorName,
    reporter: input.authorName,
    reporterId: input.authorId,
    authorId: input.authorId,
    authorName: input.authorName,
    authorAvatar: input.authorAvatar || '',
    mediaType,
    mediaUrl: media?.mediaUrl || '',
    video: media?.videoUrl || '',
    videoUrl: media?.videoUrl || '',
    image: media?.imageUrl || '',
    imageUrl: media?.imageUrl || '',
    thumbnailUrl: media?.thumbnailUrl || media?.imageUrl || '',
    cloudinaryUrl: media?.secureUrl || '',
    cloudinaryPublicId: media?.publicId || '',
    storageProvider: media ? 'cloudinary' : '',
    likes: [],
    shares: 0,
    comments: 0,
    num_comments: 0,
    status: 'publié',
    date: serverTimestamp(),
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
    format: media?.format || '',
    duration: media?.duration || null,
    width: media?.width || null,
    height: media?.height || null,
    bytes: media?.bytes || null
  });

  return docRef.id;
}

export async function toggleReportageLike(item: ReportageItem, userId: string, isLiked: boolean): Promise<void> {
  const db = getFirestoreDb();
  const itemRef = doc(db, item.docPath || `reportage/${item.id}`);
  await updateDoc(itemRef, {
    likes: isLiked ? arrayRemove(userId) : arrayUnion(userId),
    updatedAt: serverTimestamp()
  });

  if (!isLiked && item.reporterId && item.reporterId !== userId) {
    try {
      await createAppNotification({
        type: 'like',
        recipientId: item.reporterId,
        actorId: userId,
        title: item.kind === 'article' ? 'Article aimé' : 'Reportage aimé',
        body: `Votre ${item.kind === 'article' ? 'article' : 'reportage'} a reçu un like.`,
        data: {
          docPath: item.docPath || `reportage/${item.id}`
        }
      });
    } catch (error) {
      console.warn('Notification de like presse indisponible:', error);
    }
  }
}

export async function incrementReportageShare(item: ReportageItem): Promise<void> {
  const db = getFirestoreDb();
  const itemRef = doc(db, item.docPath || `reportage/${item.id}`);
  await updateDoc(itemRef, {
    shares: increment(1),
    updatedAt: serverTimestamp()
  });
}
