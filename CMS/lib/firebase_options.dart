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
    apiKey: 'AIzaSyBgzOQcDFFM3YOmYYHZvH9Le9eqpgjwGgI',
    appId: '1:396689703219:web:38c435460a3b7638913e46',
    messagingSenderId: '396689703219',
    projectId: 'mobilemaster-9c47b',
    authDomain: 'mobilemaster-9c47b.firebaseapp.com',
    storageBucket: 'mobilemaster-9c47b.appspot.com',
    measurementId: 'G-JTKLRHTSBG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1IkZnBXrLpR3wdDVAFNrf14peFOHFJIk',
    appId: '1:396689703219:android:0a9f87a560250034913e46',
    messagingSenderId: '396689703219',
    projectId: 'mobilemaster-9c47b',
    storageBucket: 'mobilemaster-9c47b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFhn8ZwiycxypUetgaNuAJipc0oyIhxcs',
    appId: '1:396689703219:ios:08153e0e10e73ca4913e46',
    messagingSenderId: '396689703219',
    projectId: 'mobilemaster-9c47b',
    storageBucket: 'mobilemaster-9c47b.appspot.com',
    iosBundleId: 'com.example.cmsAppsMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBFhn8ZwiycxypUetgaNuAJipc0oyIhxcs',
    appId: '1:396689703219:ios:08153e0e10e73ca4913e46',
    messagingSenderId: '396689703219',
    projectId: 'mobilemaster-9c47b',
    storageBucket: 'mobilemaster-9c47b.appspot.com',
    iosBundleId: 'com.example.cmsAppsMobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBgzOQcDFFM3YOmYYHZvH9Le9eqpgjwGgI',
    appId: '1:396689703219:web:bb6f7d83f8df7d2d913e46',
    messagingSenderId: '396689703219',
    projectId: 'mobilemaster-9c47b',
    authDomain: 'mobilemaster-9c47b.firebaseapp.com',
    storageBucket: 'mobilemaster-9c47b.appspot.com',
    measurementId: 'G-XYCBDHNMLT',
  );

}