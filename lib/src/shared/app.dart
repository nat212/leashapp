import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:leashapp/src/shared/providers/theme.dart';
import 'package:leashapp/src/shared/router.dart';

class LeashApp extends StatefulWidget {
  const LeashApp({Key? key}) : super(key: key);

  @override
  State<LeashApp> createState() => _LeashAppState();
}

class _LeashAppState extends State<LeashApp> {
  final settings = ValueNotifier(ThemeSettings(sourceColor: const Color(0xFF874977), themeMode: ThemeMode.system));
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) => ThemeProvider(
      lightDynamic: lightDynamic,
      darkDynamic: darkDynamic,
      settings: settings,
      child: NotificationListener<ThemeSettingsChange>(
        onNotification: (notification) {
          settings.value = notification.settings;
          return true;
        },
        child: ValueListenableBuilder<ThemeSettings>(
          valueListenable: settings,
          builder: (context, value, _) {
            final theme = ThemeProvider.of(context);
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Leash',
              theme: theme.light(settings.value.sourceColor),
              darkTheme: theme.dark(settings.value.sourceColor),
              themeMode: theme.themeMode(),
              routeInformationParser: appRouter.routeInformationParser,
              routerDelegate: appRouter.routerDelegate,
              routeInformationProvider: appRouter.routeInformationProvider,
            );
          }
        )
      )
    ));
  }
}
