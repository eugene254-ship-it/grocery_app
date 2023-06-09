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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDKqnIEYOhHTuNhKmIqEUEOk5kO4XyCi7w',
    appId: '1:346703726535:web:80ff01436364c49257fbe2',
    messagingSenderId: '346703726535',
    projectId: 'groceryapp-b7447',
    authDomain: 'groceryapp-b7447.firebaseapp.com',
    storageBucket: 'groceryapp-b7447.appspot.com',
    measurementId: 'G-5RBEGRFG4L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwbcTdK3J719w4649HimwE7ayYxTzIH3g',
    appId: '1:346703726535:android:066f3c242d4f4c0557fbe2',
    messagingSenderId: '346703726535',
    projectId: 'groceryapp-b7447',
    storageBucket: 'groceryapp-b7447.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwcOJZliGUku9IjXMDFj5h8uzxwX03Ayk',
    appId: '1:346703726535:ios:38559a940f724ffc57fbe2',
    messagingSenderId: '346703726535',
    projectId: 'groceryapp-b7447',
    storageBucket: 'groceryapp-b7447.appspot.com',
    iosClientId: '346703726535-rriqto2svklfngjg37k64icp1pq01utc.apps.googleusercontent.com',
    iosBundleId: 'com.example.groceryApp',
  );
}
