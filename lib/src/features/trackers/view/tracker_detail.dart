import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
    final tracker = TrackerProvider.instance.get(widget.trackerId);
    return Scaffold(
      appBar: AppBar(
        title: Text(tracker!.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => GoRouter.of(context).go('/'),
        ),
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
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.isMobile) {
          return _buildMobileBody(
            context: context,
            tracker: tracker,
            constraints: constraints,
          );
        } else {
          return _buildDesktopBody(
              context: context, tracker: tracker, constraints: constraints);
        }
      }),
    );
  }

  Widget _buildDesktopBody(
      {required BuildContext context,
      required Tracker tracker,
      required BoxConstraints constraints}) {
    final theme = Theme.of(context);
    final amountTheme =
        theme.textTheme.headline6!.copyWith(color: theme.colorScheme.primary);
    final amountSpent = tracker.amount * 0.7754;
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
            children: <Widget>[
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
                        value: amountSpent / tracker.amount,
                        backgroundColor: theme.colorScheme.onPrimary,
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Text(
                            NumberFormat.percentPattern()
                                .format((amountSpent / tracker.amount)),
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _formatCurrency(amountSpent),
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
                    _formatCurrency(tracker.amount),
                    style: amountTheme,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 16),
            ],
          ),
        ));
  }

  Widget _buildMobileBody(
      {required BuildContext context,
      required Tracker tracker,
      required BoxConstraints constraints}) {
    return Container();
  }

  String _formatCurrency(double amount) {
    final formatter =
        NumberFormat.simpleCurrency(name: SettingsProvider.currency.code);
    return formatter.format(amount);
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
}
