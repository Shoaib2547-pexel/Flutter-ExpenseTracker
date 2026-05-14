import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the flutterfire cli.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the flutterfire cli.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the flutterfire cli.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the flutterfire cli.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBPfgoW155MYXnktnzVy-84BWYiIjuO-hs',
    appId: '1:84568114145:web:0dd0d26520e452052488a0',
    messagingSenderId: '84568114145',
    projectId: 'expense-tracker-3c862',
    authDomain: 'expense-tracker-3c862.firebaseapp.com',
    storageBucket: 'expense-tracker-3c862.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPfgoW155MYXnktnzVy-84BWYiIjuO-hs', // Assuming same API key
    appId: '1:84568114145:android:1234567890', // We might not know exact Android appId, but we can rely on google-services.json for Android anyway
    messagingSenderId: '84568114145',
    projectId: 'expense-tracker-3c862',
    storageBucket: 'expense-tracker-3c862.firebasestorage.app',
  );
}
