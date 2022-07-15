import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:leashapp/src/shared/extensions.dart';
import 'package:leashapp/src/shared/providers/settings.dart';
import 'package:leashapp/src/shared/widgets/animated_blur.dart';

import '../../../shared/models/models.dart';
import '../../../shared/providers/theme.dart';

class TrackerCard extends StatefulWidget {
  const TrackerCard(
      {Key? key, required this.tracker, required this.constraints})
      : super(key: key);

  final Tracker tracker;
  final BoxConstraints constraints;

  @override
  State<TrackerCard> createState() => _TrackerCardState();
}

class _TrackerCardState extends State<TrackerCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ValueListenableBuilder<Settings>(
        valueListenable: SettingsProvider.instance,
        builder: (context, value, child) {
          const animationCurve = Curves.easeInOut;
          final themeBorderRadius =
              ThemeProvider.of(context).mediumBorderRadius;
          final borderRadius =
              _hovered ? BorderRadius.circular(20) : themeBorderRadius;
          return widget.constraints.isTablet
              ? MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) {
                    setState(() {
                      _hovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _hovered = false;
                    });
                  },
                  child: AnimatedContainer(
                      duration: kThemeAnimationDuration,
                      curve: animationCurve,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: theme.colorScheme.surfaceVariant,
                        border: Border.all(
                          color: theme.colorScheme.outline
                              .withOpacity(_hovered ? 1 : 0),
                          width: 1,
                        ),
                      ),
                      foregroundDecoration: BoxDecoration(
                        borderRadius: borderRadius,
                      ),
                      child: TweenAnimationBuilder<BorderRadius>(
                          duration: kThemeAnimationDuration,
                          curve: animationCurve,
                          tween: Tween(
                              begin: BorderRadius.zero, end: borderRadius),
                          builder: (context, borderRadius, child) => ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: borderRadius,
                                child: child,
                              ),
                          child: Stack(children: [
                            Container(
                              alignment: Alignment.center,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ..._cardContents(),
                                  ]),
                            ),
                            AnimatedOpacity(
                                opacity: _hovered ? 1 : 0,
                                duration: kThemeAnimationDuration,
                                curve: animationCurve,
                                child: AnimatedBlurContainer(
                                    blurRadius: _hovered ? 3.0 : 0.001,
                                    child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surface
                                              .withOpacity(0.5),
                                        ),
                                        child:
                                            widget.tracker.description == null
                                                ? Container()
                                                : Center(
                                                    child: Text(widget
                                                        .tracker.description!),
                                                  )))),
                          ]))))
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: themeBorderRadius,
                    color: theme.colorScheme.surfaceVariant,
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          ..._cardContents(),
                        ])),
                  ]),
                );
        });
  }

  List<Widget> _cardContents() {
    final theme = Theme.of(context);
    final currency = SettingsProvider.currency;
    return [
      Text(widget.tracker.name, style: Theme.of(context).textTheme.headline6),
      const SizedBox(height: 8),
      if (widget.constraints.isMobile &&
          widget.tracker.description != null) ...[
        Text(widget.tracker.description!),
        const SizedBox(height: 8),
      ],
      Center(
        child: Text('${currency.format(widget.tracker.remaining)} left',
            style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: widget.tracker.remaining <= 0
                    ? theme.colorScheme.error
                    : theme.colorScheme.secondary)),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: LinearProgressIndicator(
            value: widget.tracker.percentageSpent,
            backgroundColor: theme.colorScheme.onPrimary,
          )),
    ];
  }
}
