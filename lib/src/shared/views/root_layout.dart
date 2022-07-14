import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../router.dart' as router;
import 'adaptive_navigation.dart';

class RootLayout extends StatelessWidget {
  const RootLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  final Widget child;
  final int currentIndex;

  static const _switcherKey = ValueKey('switcherKey');
  static const _navigationRailKey = ValueKey('navigationRailKey');

  @override
  Widget build(BuildContext context) {
    void onSelected(int index) {
      final destination = router.destinations[index];
      GoRouter.of(context).go(destination.route);
    }

    return AdaptiveNavigation(
      key: _navigationRailKey,
      destinations: router.destinations
          .map((e) => NavigationDestination(icon: e.icon, label: e.label))
          .toList(),
      selectedIndex: currentIndex,
      onDestinationSelected: onSelected,
      child: Column(
        children: [
          Expanded(
            child: _Switcher(
              key: _switcherKey,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _Switcher extends StatelessWidget {
  final bool isDesktop = defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS;

  _Switcher({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return isDesktop
        ? child
        : AnimatedSwitcher(
            key: key,
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: child,
          );
  }
}
