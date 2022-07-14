import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import 'package:leashapp/src/shared/extensions.dart';

class Settings {
  const Settings({
    required this.currency,
    required this.themeMode,
  });

  final Currency currency;
  final ThemeMode themeMode;

  Settings copyWith({Currency? currency, ThemeMode? themeMode}) {
    return Settings(
      currency: currency ?? this.currency,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  operator==(Object other) =>
      identical(this, other) ||
      other is Settings &&
          runtimeType == other.runtimeType &&
          currency == other.currency &&
          themeMode == other.themeMode;

  @override
  int get hashCode => currency.hashCode ^ themeMode.hashCode;
}

class SettingsProvider extends ValueNotifier<Settings> {
  static const _currencyKey = 'currency';
  static const _themeModeKey = 'themeMode';
  static late final SettingsProvider _instance;

  static SettingsProvider get instance => _instance;
  late final SharedPreferences _prefs;

  static final CurrencyService _currencyService = CurrencyService();

  SettingsProvider({
    required Settings settings,
  }) : super(settings) {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }

  static Currency get currency => instance.value.currency;
  static ThemeMode get themeMode => instance.value.themeMode;

  static Currency _getDefaultCurrency() {
    final locale = Platform.localeName;
    final currencyFormatter = NumberFormat.currency(locale: locale);
    return _currencyService.findByCode(currencyFormatter.currencyName) ??
        _currencyService.getAll().first;
  }

  static Future<Settings> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? currencyCode = prefs.getString(_currencyKey);
    Currency currency;
    if (currencyCode != null) {
      currency =
          _currencyService.findByCode(currencyCode) ?? _getDefaultCurrency();
    } else {
      currency = _getDefaultCurrency();
    }
    final String themeModeString = prefs.getString(_themeModeKey) ?? ThemeMode.system.serialised;
    ThemeMode themeMode = ThemeMode.values
            .firstWhere((element) => element.serialised == themeModeString);
    return Settings(
      currency: currency,
      themeMode: themeMode,
    );
  }

  @override
  set value(Settings newValue) {
    if (newValue != value) {
      super.value = newValue;
      _save();
    }
  }

  void setCurrency(Currency currency) {
    value = value.copyWith(currency: currency);
  }

  void setCurrencyFromCode(String code) {
    final currency = _getCurrencyFromCode(code);
    if (currency != null) {
      setCurrency(currency);
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    value = value.copyWith(themeMode: themeMode);
  }

  Currency? _getCurrencyFromCode(String code) {
    return _currencyService.findByCode(code);
  }

  Future<void> _save() async {
    final String currencyCode = value.currency.code;
    final String themeModeString = value.themeMode.serialised;
    await _prefs.setString(_currencyKey, currencyCode);
    await _prefs.setString(_themeModeKey, themeModeString);
  }

  static Future<SettingsProvider> load() async {
    final settings = await _loadSettings();
    final provider = SettingsProvider(settings: settings);
    _instance = provider;
    return provider;
  }
}
