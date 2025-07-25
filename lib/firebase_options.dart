import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-tb03-BriNJLzyKXS41YqsaKJg98TXTM',
    appId: '1:391260086807:android:e8fa0795b2a1035270f252',
    messagingSenderId: '391260086807',
    projectId: 'fir-data-201c6',
    storageBucket: 'fir-data-201c6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBRtpco-SUbH-mg7TRyTEIx1kVHkBLYI4',
    appId: '1:391260086807:ios:3a50b762df84859a70f252',
    messagingSenderId: '391260086807',
    projectId: 'fir-data-201c6',
    storageBucket: 'fir-data-201c6.firebasestorage.app',
    androidClientId:
        '391260086807-7u9ohqqg22onqftbt4vn7rlt4cs0pofp.apps.googleusercontent.com',
    iosClientId:
        '391260086807-dp92nhhp63advoi5i3s720j08pq7vgeg.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseData',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDBRtpco-SUbH-mg7TRyTEIx1kVHkBLYI4',
    appId: '1:391260086807:ios:3a50b762df84859a70f252',
    messagingSenderId: '391260086807',
    projectId: 'fir-data-201c6',
    storageBucket: 'fir-data-201c6.firebasestorage.app',
    iosBundleId: 'com.example.firebaseData',
  );
}
