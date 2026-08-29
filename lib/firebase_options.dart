// File generated for Firebase Flutter setup (project: zeengo-d4d1b).
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCEvUPtMGDxbfT-JjONECpKnQRc67pJ97w',
    appId: '1:908024410134:android:63f54f159dc10166eb0537',
    messagingSenderId: '908024410134',
    projectId: 'zeengo-d4d1b',
    storageBucket: 'zeengo-d4d1b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCtd_mxCLkCSPdih4-upnEneYy4N51LOqc',
    appId: '1:908024410134:ios:ac3dafb2239b3a15eb0537',
    messagingSenderId: '908024410134',
    projectId: 'zeengo-d4d1b',
    storageBucket: 'zeengo-d4d1b.firebasestorage.app',
    iosBundleId: 'com.example.zeengo',
  );
}
