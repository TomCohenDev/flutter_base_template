// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyDG2zuWGksic0eIdFhGzXtWAT05ap2u1ZY",
      authDomain: "tomcohendev-portfolio.firebaseapp.com",
      projectId: "tomcohendev-portfolio",
      storageBucket: "tomcohendev-portfolio.appspot.com",
      messagingSenderId: "755195260811",
      appId: "1:755195260811:web:8ed8012d837412e887098e",
      measurementId: "G-EQS81F4SB0");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqQfRWTTCwCmDv1RhEJ1twrNAAI5c7z8o',
    appId: '1:755195260811:android:3441884d83e858c087098e',
    messagingSenderId: '755195260811',
    projectId: 'tomcohendev-portfolio',
    storageBucket: 'tomcohendev-portfolio.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIAaeaQJXLsLli7GWvNNzsi0sCZpv78EU',
    appId: '1:755195260811:ios:05c687ea7cba621887098e',
    messagingSenderId: '755195260811',
    projectId: 'tomcohendev-portfolio',
    storageBucket: 'tomcohendev-portfolio.appspot.com',
    iosBundleId: 'com.example.portfolio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAIAaeaQJXLsLli7GWvNNzsi0sCZpv78EU',
    appId: '1:755195260811:ios:05c687ea7cba621887098e',
    messagingSenderId: '755195260811',
    projectId: 'tomcohendev-portfolio',
    storageBucket: 'tomcohendev-portfolio.appspot.com',
    iosBundleId: 'com.example.portfolio',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDG2zuWGksic0eIdFhGzXtWAT05ap2u1ZY',
    appId: '1:755195260811:web:794662759bb17f3687098e',
    messagingSenderId: '755195260811',
    projectId: 'tomcohendev-portfolio',
    authDomain: 'tomcohendev-portfolio.firebaseapp.com',
    storageBucket: 'tomcohendev-portfolio.appspot.com',
  );
}
