import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension BreakpointUtils on BoxConstraints {
  bool get isTablet => maxWidth > 730;
  bool get isDesktop => maxWidth > 1200;
  bool get isMobile => !isTablet && !isDesktop;
}

extension HumanReadableName on ThemeMode {
  String get humanReadableName {
    switch (this) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return 'Unknown';
    }
  }
}

extension SerialisedThemeMode on ThemeMode {
  String get serialised {
    switch(this) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }
}

extension HumanReadableCurrency on Currency {
  String get humanReadable => '$name ($code)';
}

extension DoubleSum on Iterable<double> {
  double sum() {
    return length > 0 ? reduce((value, element) => value + element) : 0;
  }
}

extension Percentage on double {
  String percentage() {
    final formatter = NumberFormat.percentPattern();
    return formatter.format(this);
  }
}