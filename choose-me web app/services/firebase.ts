import { initializeApp, type FirebaseApp } from 'firebase/app';
import { getAuth, type Auth } from 'firebase/auth';
import { getFirestore, type Firestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: 'AIzaSyCtL0WmFOvrcG0V_0ZSwq4TCnOHRVfGnJM',
  authDomain: 'choose-me-l1izsi.firebaseapp.com',
  projectId: 'choose-me-l1izsi',
  storageBucket: 'choose-me-l1izsi.firebasestorage.app',
  messagingSenderId: '5765431920',
  appId: '1:5765431920:web:7e8f5ae884de10f7ef2ab5'
};

let app: FirebaseApp | null = null;
let auth: Auth | null = null;
let db: Firestore | null = null;

export function getFirebaseApp(): FirebaseApp {
  if (!app) {
    app = initializeApp(firebaseConfig);
  }
  return app;
}

export function getFirebaseAuth(): Auth {
  if (!auth) {
    auth = getAuth(getFirebaseApp());
  }
  return auth;
}

export function getFirestoreDb(): Firestore {
  if (!db) {
    db = getFirestore(getFirebaseApp());
  }
  return db;
}

