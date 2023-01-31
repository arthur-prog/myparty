// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfBlpfWM7TGrB_lqwmIhfjBOsJzUyL_cM',
    appId: '1:354085395529:android:30c08b6be18c4873b2b398',
    messagingSenderId: '354085395529',
    projectId: 'my-party-9cbe5',
    storageBucket: 'my-party-9cbe5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZ2CVR0Md05qWAZlPSsrSzBQ8y7l7odjE',
    appId: '1:354085395529:ios:1728ab9a0c0a3927b2b398',
    messagingSenderId: '354085395529',
    projectId: 'my-party-9cbe5',
    storageBucket: 'my-party-9cbe5.appspot.com',
    androidClientId: '354085395529-kkqte3kg7sog0strg1sjjrj79q5ogma9.apps.googleusercontent.com',
    iosClientId: '354085395529-h3e6m6itmftgmg2nj83kbiu5f33flq7e.apps.googleusercontent.com',
    iosBundleId: 'com.example.myParty',
  );
}
