import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';

class Settings {
  const Settings({
    required this.currency,
  });

  final Currency currency;
}

class SettingsProvider extends ValueNotifier<Settings> {
  static late final SettingsProvider _instance;

  static SettingsProvider get instance => _instance;

  SettingsProvider({
    required Settings settings,
  }) : super(settings);

  void setCurrency(Currency currency) {
    value = Settings(currency: currency);
  }

  SettingsProvider.initialise({required Settings settings}) : super(settings) {
    _instance = this;
  }
}
