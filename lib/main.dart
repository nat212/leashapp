import 'package:leashapp/src/shared/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leashapp/src/shared/providers/auth.dart';
import 'package:leashapp/src/shared/providers/settings.dart' as appSettings;
import 'package:window_size/window_size.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isDesktop = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux);
  if (isDesktop) {
    setWindowTitle('Leash');
    setWindowMinSize(const Size(800, 600));
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /*if (kIsWeb) {
    await FirebaseFirestore.instance.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
  } else {
    FirebaseFirestore.instance.settings =
        FirebaseFirestore.instance.settings.copyWith(persistenceEnabled: true);
  }*/
  if (!kReleaseMode) {
    String host = 'localhost';
    if (defaultTargetPlatform == TargetPlatform.android) {
      host = '10.0.2.2';
    }
    FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseStorage.instance.useStorageEmulator(host, 9199);

    try {
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    } catch (error) {
      final String code = (error as dynamic).code;
      if (code != "failed-precondition") {
        rethrow;
      }
    }
  }
  // Setup providers
  AuthProvider authProvider = AuthProvider.instance;
  await appSettings.SettingsProvider.load();
  runApp(LeashApp(authProvider: authProvider));
}
