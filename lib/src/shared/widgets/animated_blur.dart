import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedBlurContainer extends StatelessWidget {
  const AnimatedBlurContainer(
      {Key? key,
      required this.child,
      this.blurRadius = 3.0,
      this.curve = Curves.easeIn,
      this.duration = kThemeAnimationDuration})
      : super(key: key);

  final Widget child;
  final double blurRadius;
  final Curve curve;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.001, end: blurRadius),
      curve: curve,
      duration: duration,
      builder: (context, blurRadius, child) =>
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
            child: child,
          ),
      child: child,
    );
  }
}
