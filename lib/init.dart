import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leashapp/src/shared/models/models.dart';
import 'package:leashapp/src/shared/providers/settings.dart';
import 'package:leashapp/src/shared/providers/trackers.dart';
import 'package:window_size/window_size.dart';

import 'firebase_options.dart';
import 'flavors.dart';

Future<void> initialiseApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise Hive
  await _initHive();

  // Initialise window settings
  _initWindow();

  // Initialise Firebase
  await _initFirebase();

  // Setup providers
  await SettingsProvider.load();
  await TrackerProvider.initialise();
}

void _initWindow() {
  bool isDesktop = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux);
  if (isDesktop) {
    setWindowTitle(F.title);
    setWindowMinSize(const Size(800, 600));
  }
}

Future<void> _initHive() async {
  Hive.registerAdapter(TrackerAdapter());
  Hive.registerAdapter(LogAdapter());
  await Hive.initFlutter();
}

Future<void> _initFirebase() async {
  bool supportsFirebase = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      kIsWeb;
  if (!supportsFirebase) {
    return;
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
}
