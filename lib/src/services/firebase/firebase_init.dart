import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/src/services/firebase/firebase_options.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .whenComplete(() => print('Firebase initialized'));
}
