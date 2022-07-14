import 'package:flutter/material.dart';

class Clickable extends StatelessWidget {
  const Clickable({Key? key, required this.child, required this.onTap}) : super(key: key);

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
