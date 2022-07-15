import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leashapp/src/shared/app.dart';
import 'package:leashapp/src/shared/providers/settings.dart' as appSettings;
import 'package:leashapp/src/shared/providers/trackers.dart';
import 'package:window_size/window_size.dart';

import 'firebase_options.dart';
import 'src/shared/models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.registerAdapter(TrackerAdapter());
  Hive.registerAdapter(LogAdapter());
  await Hive.initFlutter();
  bool isDesktop = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux);

  bool supportsFirebase = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      kIsWeb;

  if (supportsFirebase) {
    await _initFirebase();
  }

  if (isDesktop) {
    setWindowTitle('Leash');
    setWindowMinSize(const Size(800, 600));
  }

  // Setup providers
  await appSettings.SettingsProvider.load();
  await TrackerProvider.initialise();
  runApp(const LeashApp());
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
}
