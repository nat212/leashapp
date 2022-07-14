import 'package:flutter/foundation.dart';

class LoggerService {

  LoggerService(this.cls);

  final Type cls;

  void log(String message) {
    if (kDebugMode) {
      print('${cls.toString()}: $message');
    }
  }
}