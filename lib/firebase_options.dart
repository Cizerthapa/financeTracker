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
    apiKey: 'AIzaSyAUpOadj3xVeqpfR8_99abNVV4eSRawq0g',
    appId: '1:716594885355:web:f0be44c9483fba7baa04ae',
    messagingSenderId: '716594885355',
    projectId: 'finance-tracker-98d9c',
    authDomain: 'finance-tracker-98d9c.firebaseapp.com',
    storageBucket: 'finance-tracker-98d9c.firebasestorage.app',
    measurementId: 'G-WQRCM74H99',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCyQQZZR0B7Ikkd0FKgwCVV2KmC-J62Iqo',
    appId: '1:716594885355:android:d33d8435c926a764aa04ae',
    messagingSenderId: '716594885355',
    projectId: 'finance-tracker-98d9c',
    storageBucket: 'finance-tracker-98d9c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGugN2IlKAjosZA0nPU3m1OG3EuG4Bp-s',
    appId: '1:716594885355:ios:d2073449cec67f96aa04ae',
    messagingSenderId: '716594885355',
    projectId: 'finance-tracker-98d9c',
    storageBucket: 'finance-tracker-98d9c.firebasestorage.app',
    iosBundleId: 'com.example.financeTrack',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGugN2IlKAjosZA0nPU3m1OG3EuG4Bp-s',
    appId: '1:716594885355:ios:d2073449cec67f96aa04ae',
    messagingSenderId: '716594885355',
    projectId: 'finance-tracker-98d9c',
    storageBucket: 'finance-tracker-98d9c.firebasestorage.app',
    iosBundleId: 'com.example.financeTrack',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAUpOadj3xVeqpfR8_99abNVV4eSRawq0g',
    appId: '1:716594885355:web:c2805bb9712d7d2caa04ae',
    messagingSenderId: '716594885355',
    projectId: 'finance-tracker-98d9c',
    authDomain: 'finance-tracker-98d9c.firebaseapp.com',
    storageBucket: 'finance-tracker-98d9c.firebasestorage.app',
    measurementId: 'G-LZCK9BDN7Q',
  );
}
