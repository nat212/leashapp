import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_donation_buttons/donationButtons/ko-fiButton.dart';
import 'package:flutter_donation_buttons/donationButtons/paypalButton.dart';
import 'package:go_router/go_router.dart';
import 'package:leashapp/src/shared/providers/app_info.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/settings'),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.topCenter,
        constraints: BoxConstraints(
          maxWidth: min(constraints.maxWidth, 600),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Leash',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 16),
              Text(
                'Version ${AppInfo.version}, build ${AppInfo.buildNumber}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 16),
              Text(
                'Package name: ${AppInfo.packageName}',
              ),
              const SizedBox(height: 16),
              const Spacer(),
              const KofiButton(
                kofiName: 'natashadraper',
                kofiColor: KofiColor.Red,
              ),
              const PayPalButton(paypalButtonId: '9WEJ326GKFE62'),
              const Spacer(),
              Text(
                'Copyright © 2022 Natasha Draper. All rights reserved.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
              ),
            ]),
      );
    });
  }
}
