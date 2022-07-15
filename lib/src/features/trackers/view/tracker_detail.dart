import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leashapp/src/shared/extensions.dart';
import 'package:leashapp/src/shared/providers/settings.dart';
import 'package:leashapp/src/shared/providers/trackers.dart';

import '../../../shared/models/models.dart';

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
              ? ValueListenableBuilder(
                  valueListenable: (tracker.logs!.box as Box).listenable(),
                  builder: (context, box, _) {
                    return Scaffold(
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
                    );
                  })
              : Container();
        });
  }

  List<Widget> _buildHeader(Tracker tracker) {
    final theme = Theme.of(context);
    final amountTheme =
        theme.textTheme.headline6!.copyWith(color: theme.colorScheme.primary);
    final errorTheme = amountTheme.copyWith(color: theme.colorScheme.error);
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
                    min(tracker.percentageSpent, 1.0).percentage(),
                    style: tracker.percentageSpent >= 1.0
                        ? theme.textTheme.bodySmall!
                            .copyWith(color: theme.colorScheme.error)
                        : theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            SettingsProvider.currency.format(tracker.totalSpent),
            style: tracker.percentageSpent >= 1 ? errorTheme : amountTheme,
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
    ];
  }

  Widget _buildLogList(
      BuildContext context, Tracker tracker, BoxConstraints constraints) {
    return tracker.logs!.isNotEmpty
        ? ListView.builder(
            itemCount: tracker.logs!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final log = tracker.logs![index];
              return ListTile(
                title: Text(log.label),
                subtitle: Text(SettingsProvider.currency.format(log.amount)),
                onTap: () {
                  context.go('/trackers/${tracker.key}/log/${log.key}');
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteLog(log),
                ),
              );
            })
        : Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 16),
            child: const Text('No spendings have been logged yet'),
          );
  }

  Future<void> _deleteLog(Log log) async {
    final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Log'),
              content: const Text('Are you sure you want to delete this log?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
    if (result == true) {
      log.delete();
    }
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
              _buildLogList(context, tracker, constraints),
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
          _buildLogList(context, tracker, constraints),
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
    context.go('/trackers/${tracker.key}/edit');
  }

  void _logSpend(Tracker tracker) {
    context.go('/trackers/${tracker.key}/log');
  }
}
