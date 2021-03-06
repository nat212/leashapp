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
        return macos;
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
    apiKey: 'AIzaSyC_MPXB5P86aDZEx1B79kBD1_NeoK4Kmxw',
    appId: '1:720481261480:web:9ebe2eeba5a0792fbeef9d',
    messagingSenderId: '720481261480',
    projectId: 'leashapp-co-za',
    authDomain: 'leashapp-co-za.firebaseapp.com',
    storageBucket: 'leashapp-co-za.appspot.com',
    measurementId: 'G-3HMCD1KSMY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAA6WgS0lJEFNCBY7U1Aks9dGw5F4FuqAA',
    appId: '1:720481261480:android:4a66dcdaa0308f43beef9d',
    messagingSenderId: '720481261480',
    projectId: 'leashapp-co-za',
    storageBucket: 'leashapp-co-za.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAYbvTITP7eeMOroVKGkmms6IkUd_TQ-o',
    appId: '1:720481261480:ios:a03dde67b9a98e29beef9d',
    messagingSenderId: '720481261480',
    projectId: 'leashapp-co-za',
    storageBucket: 'leashapp-co-za.appspot.com',
    androidClientId:
        '720481261480-ic9t5bqncpdkt7srsgr2fidqemkukhgq.apps.googleusercontent.com',
    iosClientId:
        '720481261480-8pmpk47irvjlbcb0026naatlq8g3sgm2.apps.googleusercontent.com',
    iosBundleId: 'za.co.leashapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDAYbvTITP7eeMOroVKGkmms6IkUd_TQ-o',
    appId: '1:720481261480:ios:a03dde67b9a98e29beef9d',
    messagingSenderId: '720481261480',
    projectId: 'leashapp-co-za',
    storageBucket: 'leashapp-co-za.appspot.com',
    androidClientId:
        '720481261480-ic9t5bqncpdkt7srsgr2fidqemkukhgq.apps.googleusercontent.com',
    iosClientId:
        '720481261480-8pmpk47irvjlbcb0026naatlq8g3sgm2.apps.googleusercontent.com',
    iosBundleId: 'za.co.leashapp',
  );
}
