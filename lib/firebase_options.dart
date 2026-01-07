import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBeeJ8o2PRLm9Cqlm2kri4ZPhyaPCL1-00',
    appId: '1:112296304570:web:3dc727a071da0e88f98783',
    messagingSenderId: '112296304570',
    projectId: 'optilook-ab208',
    authDomain: 'optilook-ab208.firebaseapp.com',
    storageBucket: 'optilook-ab208.firebasestorage.app',
    measurementId: 'G-5Y4YJW4W3G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDX9OMDOaUmeOr6SKytBWp70K7rMANURzk',
    appId: '1:112296304570:android:dc1bc587753ca359f98783',
    messagingSenderId: '112296304570',
    projectId: 'optilook-ab208',
    storageBucket: 'optilook-ab208.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDC8gUalQtM1mtd2RC7dzFiYG2WzyLqxm4',
    appId: '1:112296304570:ios:8be38c47b87aa39df98783',
    messagingSenderId: '112296304570',
    projectId: 'optilook-ab208',
    storageBucket: 'optilook-ab208.firebasestorage.app',
    iosBundleId: 'com.example.tpFlutterOptilook',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDC8gUalQtM1mtd2RC7dzFiYG2WzyLqxm4',
    appId: '1:112296304570:ios:8be38c47b87aa39df98783',
    messagingSenderId: '112296304570',
    projectId: 'optilook-ab208',
    storageBucket: 'optilook-ab208.firebasestorage.app',
    iosBundleId: 'com.example.tpFlutterOptilook',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBeeJ8o2PRLm9Cqlm2kri4ZPhyaPCL1-00',
    appId: '1:112296304570:web:b95fd9a218a6a1adf98783',
    messagingSenderId: '112296304570',
    projectId: 'optilook-ab208',
    authDomain: 'optilook-ab208.firebaseapp.com',
    storageBucket: 'optilook-ab208.firebasestorage.app',
    measurementId: 'G-WMRJBH6XJ8',
  );
}
