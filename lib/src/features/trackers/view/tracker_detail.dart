import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leashapp/src/shared/extensions.dart';
import 'package:leashapp/src/shared/providers/settings.dart';
import 'package:leashapp/src/shared/providers/trackers.dart';

import '../../../shared/models/models.dart';
import '../trackers.dart';

class TrackerDetail extends StatefulWidget {
  const TrackerDetail({Key? key, required this.trackerId}) : super(key: key);

  final int trackerId;

  @override
  State<TrackerDetail> createState() => _TrackerDetailState();
}

class _TrackerDetailState extends State<TrackerDetail> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TrackerProvider>(
        valueListenable: TrackerProvider.instance.listenable,
        builder: (context, provider, _) {
          final tracker = provider.get(widget.trackerId);
          return tracker != null
              ? Scaffold(
                  appBar: AppBar(
                    title: Text(tracker.name),
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => GoRouter.of(context).pop(),
                    ),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editTracker(tracker),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTracker(tracker),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                      onPressed: () {
                        _logSpend(tracker);
                      },
                      label: const Text('Log Spend'),
                      icon: const Icon(Icons.account_balance_wallet)),
                  body: SingleChildScrollView(
                      child: LayoutBuilder(builder: (context, constraints) {
                    if (constraints.isMobile) {
                      return _buildMobileBody(
                        context: context,
                        tracker: tracker,
                        constraints: constraints,
                      );
                    } else {
                      return _buildDesktopBody(
                          context: context,
                          tracker: tracker,
                          constraints: constraints);
                    }
                  })),
                )
              : Container();
        });
  }

  List<Widget> _buildHeader(Tracker tracker) {
    final theme = Theme.of(context);
    final amountTheme =
        theme.textTheme.headline6!.copyWith(color: theme.colorScheme.primary);
    return <Widget>[
      if (tracker.description != null)
        Text(tracker.description!,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center),
      if (tracker.description != null) const SizedBox(height: 32),
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: tracker.percentageSpent,
                backgroundColor: theme.colorScheme.onPrimary,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    tracker.percentageSpent.percentage(),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            SettingsProvider.currency.format(tracker.totalSpent),
            style: amountTheme,
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 8),
          Text(
            '/',
            style: amountTheme,
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 8),
          Text(
            SettingsProvider.currency.format(tracker.amount),
            style: amountTheme,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      const SizedBox(height: 4),
      const Divider(),
      const SizedBox(height: 16),
    ];
  }

  Widget _buildDesktopBody(
      {required BuildContext context,
      required Tracker tracker,
      required BoxConstraints constraints}) {
    return Container(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: min(constraints.maxWidth * 0.6, 600),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ..._buildHeader(tracker),
            ],
          ),
        ));
  }

  Widget _buildMobileBody(
      {required BuildContext context,
      required Tracker tracker,
      required BoxConstraints constraints}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ..._buildHeader(tracker),
        ],
      ),
    );
  }

  void _deleteTracker(Tracker tracker) async {
    final bool result = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Delete Tracker'),
                content:
                    Text('Are you sure you want to delete ${tracker.name}?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            }) ??
        false;
    if (result) {
      tracker.delete();
      _exit();
    }
  }

  void _exit() {
    GoRouter.of(context).go('/');
  }

  void _editTracker(Tracker tracker) async {
    final result = await showDialog(
        context: context, builder: (context) => AddTracker(tracker: tracker));
    if (result is Tracker) {
      result.save();
    }
  }

  void _logSpend(Tracker tracker) {
    context.go('/trackers/${tracker.key}/log');
  }
}
