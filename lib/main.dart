import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leashapp/src/shared/app.dart';
import 'package:window_size/window_size.dart';

void main() {
  bool isDesktop = (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux) &&
      !kIsWeb;
  if (isDesktop) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Leash');
    setWindowMinSize(const Size(800, 600));
  }
  runApp(const LeashApp());
}
