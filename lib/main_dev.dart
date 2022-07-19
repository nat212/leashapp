import 'package:flutter/material.dart';
import 'package:leashapp/init.dart';

import 'app.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.dev;
  await initialiseApp();
  runApp(App());
}
