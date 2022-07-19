import 'package:flutter/material.dart';
import 'package:leashapp/init.dart';
import 'package:leashapp/src/shared/app.dart';

void main() async {
  await initialiseApp();
  runApp(const LeashApp());
}
