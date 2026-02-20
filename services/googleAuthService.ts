import { Capacitor } from '@capacitor/core';
import {
  type Auth,
  type User,
  GoogleAuthProvider,
  getRedirectResult,
  signInWithPopup,
  signInWithRedirect
} from 'firebase/auth';
import { doc, getDoc, serverTimestamp, setDoc } from 'firebase/firestore';
import { UserType } from '../types';
import { getFirestoreDb } from './firebase';

export type GoogleStartResult =
  | { mode: 'popup'; user: User }
  | { mode: 'redirect' };

const GOOGLE_REDIRECT_PENDING_KEY = 'chooseme:google_redirect_pending';

function setGoogleRedirectPending(pending: boolean): void {
  if (typeof window === 'undefined' || !window.sessionStorage) return;
  if (pending) {
    window.sessionStorage.setItem(GOOGLE_REDIRECT_PENDING_KEY, '1');
  } else {
    window.sessionStorage.removeItem(GOOGLE_REDIRECT_PENDING_KEY);
  }
}

export function hasGoogleRedirectPending(): boolean {
  if (typeof window === 'undefined' || !window.sessionStorage) return false;
  return window.sessionStorage.getItem(GOOGLE_REDIRECT_PENDING_KEY) === '1';
}

export function clearGoogleRedirectPending(): void {
  setGoogleRedirectPending(false);
}

function isMobileWeb(): boolean {
  if (typeof window === 'undefined' || typeof navigator === 'undefined') return false;
  const ua = navigator.userAgent || '';
  const mobileUA = /Android|iPhone|iPad|iPod|Mobile|Opera Mini|IEMobile/i.test(ua);
  const touch = typeof window.matchMedia === 'function' && window.matchMedia('(pointer: coarse)').matches;
  return mobileUA || touch;
}

export async function startGoogleAuth(auth: Auth): Promise<GoogleStartResult> {
  const provider = new GoogleAuthProvider();
  provider.setCustomParameters({ prompt: 'select_account' });
  const isNative = Capacitor.isNativePlatform();
  const mobileWeb = isMobileWeb();

  // Mobile web + APK: flux redirect plus fiable que popup (retour système/webview).
  if (isNative || mobileWeb) {
    setGoogleRedirectPending(true);
    await signInWithRedirect(auth, provider);
    return { mode: 'redirect' };
  }

  try {
    // Desktop web: popup d'abord pour une expérience plus rapide.
    const result = await signInWithPopup(auth, provider);
    setGoogleRedirectPending(false);
    return { mode: 'popup', user: result.user };
  } catch (error: any) {
    // Fallback robuste: redirect uniquement si popup indisponible/bloquée.
    if (
      error?.code === 'auth/popup-blocked' ||
      error?.code === 'auth/operation-not-supported-in-this-environment' ||
      error?.code === 'auth/cancelled-popup-request' ||
      error?.code === 'auth/internal-error'
    ) {
      setGoogleRedirectPending(true);
      await signInWithRedirect(auth, provider);
      return { mode: 'redirect' };
    }

    throw error;
  }
}

export async function getPendingGoogleRedirectUser(auth: Auth): Promise<User | null> {
  try {
    const result = await getRedirectResult(auth);
    return result?.user ?? null;
  } catch (error: any) {
    // Tolérer les environnements sans redirect resolver initialisé.
    if (error?.code === 'auth/argument-error') {
      return null;
    }
    throw error;
  }
}

export async function ensureUserProfile(user: User): Promise<{ isNewUser: boolean }> {
  const db = getFirestoreDb();
  const userRef = doc(db, 'users', user.uid);
  const snap = await getDoc(userRef);

  if (snap.exists()) {
    return { isNewUser: false };
  }

  await setDoc(userRef, {
    email: user.email || '',
    displayName: user.displayName || user.email?.split('@')[0] || 'Utilisateur',
    photoUrl: user.photoURL || null,
    type: UserType.VISITOR,
    statut: 'no',
    etat: 'nv',
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp()
  });

  return { isNewUser: true };
}
