import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';
import { getStorage } from 'firebase/storage';

// ATTENTION:
// Copier ici la configuration Firebase de votre projet (depuis Flutter / console Firebase)
// pour réutiliser le même backend.

const firebaseConfig = {
  apiKey: 'CHANGE_ME',
  authDomain: 'CHANGE_ME',
  projectId: 'CHANGE_ME',
  storageBucket: 'CHANGE_ME',
  messagingSenderId: 'CHANGE_ME',
  appId: 'CHANGE_ME'
};

const app = initializeApp(firebaseConfig);

export const firebaseAuth = getAuth(app);
export const firebaseDb = getFirestore(app);
export const firebaseStorage = getStorage(app);

