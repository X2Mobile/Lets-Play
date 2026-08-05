import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Firebase project `let-s-play-52f6a`, transcribed from the console configs
/// (`ios/Runner/GoogleService-Info.plist`, `android/app/google-services.json`).
///
/// Only Android and iOS have registered apps; other platforms throw and
/// [AnalyticsService] degrades to a no-op rather than crashing the demo.
class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'No Firebase web app is registered for this project.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'No Firebase app is registered for $defaultTargetPlatform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9A5T4VUfeDP_Vd4coXrz9dckQw53wGi8',
    appId: '1:69829573284:android:324ca8a7353ee74ed60431',
    messagingSenderId: '69829573284',
    projectId: 'let-s-play-52f6a',
    storageBucket: 'let-s-play-52f6a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_lIrAYeMxbuVEniUy5IaOh_rIxldJh4o',
    appId: '1:69829573284:ios:ff480f6a12b5dbc9d60431',
    messagingSenderId: '69829573284',
    projectId: 'let-s-play-52f6a',
    storageBucket: 'let-s-play-52f6a.firebasestorage.app',
    iosBundleId: 'com.x2mobile.letsplaygame',
  );
}
