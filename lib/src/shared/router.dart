import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leashapp/src/features/home/view/home_screen.dart';
import 'package:leashapp/src/features/settings/view/signin_screen.dart';
import 'package:leashapp/src/features/trackers/trackers.dart';
import 'package:leashapp/src/shared/views/root_layout.dart';

import '../features/settings/settings.dart';

const _pageKey = ValueKey('_pageKey');
const _scaffoldKey = ValueKey('_scaffoldKey');

class NavigationDestination {
  const NavigationDestination({
    required this.route,
    required this.label,
    required this.icon,
    this.child,
  });

  final String route;
  final String label;
  final Icon icon;
  final Widget? child;
}

const List<NavigationDestination> destinations = [
  NavigationDestination(
    label: 'Trackers',
    icon: Icon(Icons.track_changes),
    route: '/',
  ),
  NavigationDestination(
    label: 'Settings',
    icon: Icon(Icons.settings),
    route: '/settings',
  ),
];

final appRouter = GoRouter(
  restorationScopeId: 'leashapp',
  urlPathStrategy: UrlPathStrategy.path,
  navigatorBuilder: (context, state, child) => child,
  routes: [
    // HomeScreen
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 0,
          child: HomeScreen(),
        ),
      ),
    ),
    GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => const MaterialPage<void>(
            key: _pageKey,
            child: RootLayout(
              key: _scaffoldKey,
              currentIndex: 1,
              child: SettingsScreen(),
            ))),
    GoRoute(
        path: '/signin',
        pageBuilder: (context, state) => const MaterialPage<void>(
            key: _pageKey,
            child: RootLayout(
                key: _scaffoldKey, currentIndex: 1, child: SigninScreen()))),
    GoRoute(
      path: '/trackers/:id',
      pageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 0,
          child: TrackerDetail(trackerId: int.parse(state.params['id']!)),
        ),
      ),
    ),
  ],
);
