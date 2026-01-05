import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCtL0WmFOvrcG0V_0ZSwq4TCnOHRVfGnJM",
            authDomain: "choose-me-l1izsi.firebaseapp.com",
            projectId: "choose-me-l1izsi",
            storageBucket: "choose-me-l1izsi.firebasestorage.app",
            messagingSenderId: "5765431920",
            appId: "1:5765431920:web:7e8f5ae884de10f7ef2ab5"));
  } else {
    await Firebase.initializeApp();
  }
}
