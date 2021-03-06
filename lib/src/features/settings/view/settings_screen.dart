import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leashapp/src/shared/extensions.dart';
import 'package:leashapp/src/shared/providers/app_info.dart';
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
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(32),
          child: ListView(
            children: <Widget>[
              // TODO: Add syncing
              // _buildAccountSection(),
              // const SizedBox(height: 16),
              _buildThemeModeToggle(),
              const SizedBox(
                height: 16,
              ),
              _buildCurrencyToggle(),
              _buildAboutSection(),
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

  Widget _buildAboutSection() {
    return ListTile(
      title: const Text('About'),
      subtitle: Text(AppInfo.summary),
      onTap: () {
        context.go('/about');
      },
    );
  }

  void _setCurrency() {
    showCurrencyPicker(
        context: context,
        favorite: [_currency.code],
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
    SettingsProvider.instance.setThemeMode(value);
    ThemeSettingsChange(settings: newSettings).dispatch(context);
  }

 /* Widget _buildAccountSection() {
    return UserBuilder(builder: (context, user) {
      return user == null || user.isAnonymous
          ? ListTile(
              title: const Text('Sync'),
              subtitle:
                  const Text('Create an account or sign in to sync your data.'),
              onTap: () => GoRouter.of(context).go('/signin'),
              trailing: const Icon(Icons.person),
            )
          : ListTile(
              title: const Text('Account'),
              subtitle: Text('${user.email}'),
              trailing: const Icon(Icons.person),
            );
    });
  }*/
}
