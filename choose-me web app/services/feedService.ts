import { collectionGroup, getDocs, orderBy, query } from 'firebase/firestore';
import { getFirestoreDb } from './firebase';
import type { FeedPost } from '../types';

// Récupère les vidéos depuis Firestore en utilisant la même structure que Flutter :
// sous-collection "publication" (PublicationRecord) avec le champ "postVido".
export async function fetchVideoFeed(): Promise<FeedPost[]> {
  const db = getFirestoreDb();

  try {
    const q = query(
      collectionGroup(db, 'publication'),
      orderBy('time_posted', 'desc')
    );
    const snap = await getDocs(q);

    if (snap.empty) return [];

    const items: FeedPost[] = [];

    snap.forEach((docSnap) => {
      const data = docSnap.data() as any;

      // Dans Firestore, les champs viennent de Flutter avec des noms snake_case :
      // postVido, post_photo, post_title, post_description, ashtag, type, etc.
      const rawUrl = (data.postVido as string | undefined) ?? (data.post_vido as string | undefined);
      const videoUrl = rawUrl?.trim();

      // On garde seulement les docs avec un champ vidéo non vide
      if (!videoUrl) return;

      const createdAt: string =
        data.time_posted && data.time_posted.toDate
          ? data.time_posted.toDate().toLocaleDateString()
          : '';

      // Hashtags : on combine "ashtag" (string) et "type" (liste de strings)
      const hashtags: string[] = [];
      if (typeof data.ashtag === 'string' && data.ashtag.trim()) {
        hashtags.push(
          ...data.ashtag
            .trim()
            .split(/\s+/)
            .filter((t: string) => t.length > 0)
        );
      }
      if (Array.isArray(data.type)) {
        hashtags.push(
          ...data.type.filter((t: unknown) => typeof t === 'string' && (t as string).trim().length > 0)
        );
      }

      items.push({
        id: docSnap.id,
        userId: (data.post_user && data.post_user.id) || '',
        userName: data.nomPoster || 'Talent',
        userAvatar: data.post_photo || '/assets/images/Sans_titre-2_(4).png',
        type: 'video',
        url: videoUrl,
        thumbnail: data.post_photo || '',
        caption: data.post_description || '',
        likes: Array.isArray(data.likes) ? data.likes.length : 0,
        shares: data.num_votes ?? 0,
        comments: data.num_comments ?? 0,
        createdAt,
        hashtags,
        docPath: docSnap.ref.path
      });
    });

    return items;
  } catch (e) {
    console.error('Erreur chargement vidéos Firestore (publication):', e);
    return [];
  }
}

