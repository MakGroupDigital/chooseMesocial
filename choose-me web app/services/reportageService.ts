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

export type PressContentKind = 'article' | 'reportage';
export type PressMediaType = 'none' | 'image' | 'video';

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

const countLikes = (value: unknown): number => {
  if (Array.isArray(value)) return value.length;
  if (typeof value === 'number' && Number.isFinite(value)) return value;
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

async function uploadPressMedia(file: File, userId: string): Promise<PressMediaUploadResult> {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('userId', userId);

  const response = await fetch('/api/reportage-media', {
    method: 'POST',
    body: formData
  });

  const payload = await response.json().catch(() => null) as PressMediaUploadResult | { error?: string; detail?: string } | null;

  if (!response.ok || !payload || !('mediaUrl' in payload)) {
    const detail = payload && 'detail' in payload && payload.detail ? ` (${payload.detail})` : '';
    throw new Error(`${payload && 'error' in payload ? payload.error : 'Impossible d’uploader le média.'}${detail}`);
  }

  return payload;
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
}

export async function incrementReportageShare(item: ReportageItem): Promise<void> {
  const db = getFirestoreDb();
  const itemRef = doc(db, item.docPath || `reportage/${item.id}`);
  await updateDoc(itemRef, {
    shares: increment(1),
    updatedAt: serverTimestamp()
  });
}
