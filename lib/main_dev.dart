import 'package:flutter/material.dart';
import 'package:leashapp/init.dart';
import 'package:leashapp/src/shared/app.dart';

import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.DEV;
  await initialiseApp();
  runApp(const LeashApp());
}
