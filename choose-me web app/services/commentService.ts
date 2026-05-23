import {
  addDoc,
  collection,
  doc,
  getDocs,
  orderBy,
  query,
  serverTimestamp,
  updateDoc,
  increment
} from 'firebase/firestore';
import { getFirestoreDb } from './firebase';
import type { PostComment, PostCommentReply } from '../types';
import { normalizeEngagementCount } from '../utils/engagement';

// Sous-collection de commentaires par publication :
// /users/{userId}/publication/{pubId}/comments/{commentId}
// ou toute autre racine, puisque nous utilisons le chemin complet stocké dans FeedPost.

export async function fetchComments(docPath: string): Promise<PostComment[]> {
  const db = getFirestoreDb();
  const publicationRef = doc(db, docPath);
  const commentsCol = collection(publicationRef, 'comments');

  const q = query(commentsCol, orderBy('createdAt', 'asc'));
  const snap = await getDocs(q);

  return Promise.all(snap.docs.map(async (d) => {
    const data = d.data() as any;
    const createdAt =
      data.createdAt && data.createdAt.toDate
        ? data.createdAt.toDate().toLocaleString()
        : '';

    let replies: PostCommentReply[] = [];
    try {
      const repliesSnap = await getDocs(query(collection(d.ref, 'replies'), orderBy('createdAt', 'asc')));
      replies = repliesSnap.docs.map((replyDoc) => {
        const replyData = replyDoc.data() as any;
        const replyCreatedAt =
          replyData.createdAt && replyData.createdAt.toDate
            ? replyData.createdAt.toDate().toLocaleString()
            : '';

        return {
          id: replyDoc.id,
          userId: replyData.userId || '',
          userName: replyData.userName || 'Utilisateur',
          userAvatar: replyData.userAvatar || undefined,
          text: replyData.text || '',
          createdAt: replyCreatedAt,
        };
      });
    } catch (error) {
      console.warn('Impossible de charger les réponses du commentaire:', d.id, error);
    }

    return {
      id: d.id,
      userId: data.userId || '',
      userName: data.userName || 'Utilisateur',
      userAvatar: data.userAvatar || undefined,
      text: data.text || '',
      createdAt,
      likes: normalizeEngagementCount(data.likes),
      replies,
      replyCount: normalizeEngagementCount(data.replyCount ?? replies.length)
    };
  }));
}

export async function addComment(options: {
  docPath: string;
  userId: string;
  userName: string;
  userAvatar?: string;
  text: string;
}): Promise<string> {
  const db = getFirestoreDb();
  const publicationRef = doc(db, options.docPath);
  const commentsCol = collection(publicationRef, 'comments');

  const commentRef = await addDoc(commentsCol, {
    userId: options.userId,
    userName: options.userName,
    userAvatar: options.userAvatar ?? null,
    text: options.text.trim(),
    createdAt: serverTimestamp(),
    likes: 0,
    replyCount: 0
  });

  // Incrémente num_comments sur la publication pour rester cohérent avec Flutter.
  try {
    await updateDoc(publicationRef, {
      num_comments: increment(1)
    });
  } catch (e) {
    // Si l'incrément échoue, ce n'est pas bloquant pour l'ajout du commentaire.
    console.warn('Impossible de mettre à jour num_comments:', e);
  }

  return commentRef.id;
}

export async function addCommentReply(options: {
  docPath: string;
  commentId: string;
  userId: string;
  userName: string;
  userAvatar?: string;
  text: string;
}): Promise<string> {
  const db = getFirestoreDb();
  const publicationRef = doc(db, options.docPath);
  const commentRef = doc(db, `${options.docPath}/comments/${options.commentId}`);
  const repliesCol = collection(commentRef, 'replies');

  const replyRef = await addDoc(repliesCol, {
    userId: options.userId,
    userName: options.userName,
    userAvatar: options.userAvatar ?? null,
    text: options.text.trim(),
    createdAt: serverTimestamp()
  });

  try {
    await updateDoc(commentRef, {
      replyCount: increment(1)
    });
  } catch (e) {
    console.warn('Impossible de mettre à jour replyCount:', e);
  }

  try {
    await updateDoc(publicationRef, {
      num_comments: increment(1)
    });
  } catch (e) {
    console.warn('Impossible de mettre à jour num_comments après réponse:', e);
  }

  return replyRef.id;
}

export async function likeComment(options: {
  docPath: string;
  commentId: string;
}): Promise<void> {
  const db = getFirestoreDb();
  const commentRef = doc(db, `${options.docPath}/comments/${options.commentId}`);
  await updateDoc(commentRef, {
    likes: increment(1)
  });
}
