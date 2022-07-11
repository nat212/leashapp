import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:leashapp/src/shared/extensions.dart';
import 'package:leashapp/src/shared/providers/settings.dart';

import '../../../shared/providers/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _brightness;
  late Currency _currency;

  @override
  Widget build(BuildContext context) {
    _brightness = ThemeProvider.of(context).settings.value.themeMode;
    _currency = SettingsProvider.instance.value.currency;
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(32),
          child: ListView(
            children: <Widget>[
              _buildThemeModeToggle(),
              const SizedBox(
                height: 16,
              ),
              _buildCurrencyToggle(),
            ],
          )),
    );
  }

  Widget _buildThemeModeToggle() {
    return DropdownButtonFormField<ThemeMode>(
        decoration: const InputDecoration(
          labelText: 'Theme Mode',
        ),
        items: ThemeMode.values
            .map((e) =>
                DropdownMenuItem(value: e, child: Text(e.humanReadableName)))
            .toList(),
        value: _brightness,
        onChanged: (ThemeMode? value) {
          if (value != null) {
            _setThemeMode(value);
          }
        });
  }

  Widget _buildCurrencyToggle() {
    return ListTile(
      title: const Text('Currency'),
      subtitle: Text(_currency.humanReadable),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () {
        _setCurrency();
      },
    );
  }

  void _setCurrency() {
    showCurrencyPicker(
        context: context,
        favorite: {_currency.code, 'ZAR', 'USD'}.toList(),
        onSelect: (Currency currency) {
          setState(() {
            _currency = currency;
          });
          SettingsProvider.instance.setCurrency(currency);
        });
  }

  void _setThemeMode(ThemeMode value) {
    setState(() {
      _brightness = value;
    });
    final settings = ThemeProvider.of(context).settings.value;
    final newSettings = ThemeSettings(
      sourceColor: settings.sourceColor,
      themeMode: value,
    );
    ThemeSettingsChange(settings: newSettings).dispatch(context);
  }
}
