import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leashapp/src/shared/providers/settings.dart';
import 'package:leashapp/src/shared/providers/trackers.dart';

import '../../../shared/classes/tracker.dart';

class TrackerCard extends StatefulWidget {
  const TrackerCard({Key? key, required this.tracker, required this.provider})
      : super(key: key);

  final Tracker tracker;
  final TrackersProvider provider;

  @override
  State<TrackerCard> createState() => _TrackerCardState();
}

class _TrackerCardState extends State<TrackerCard> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ValueListenableBuilder<Settings>(
        valueListenable: SettingsProvider.instance,
        builder: (context, value, child) {
          final Currency currency = value.currency;
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Text(widget.tracker.name,
                              style: Theme.of(context).textTheme.headline6),
                          const SizedBox(height: 16),
                          if (widget.tracker.description != null)
                            Text(widget.tracker.description!, overflow: TextOverflow.ellipsis),
                          const Spacer(),
                          Text(
                              '${_amountAsCurrency(widget.tracker.amount, currency)} left',
                              style: theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.secondary)),
                        ]))),
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            _deleteTracker(widget.tracker);
                          },
                          icon: const Icon(Icons.delete),
                          color: theme.colorScheme.error,
                        ),
                      ],
                    ))
              ],
            ),
          );
        });
  }

  void _deleteTracker(Tracker tracker) async {
    final bool result = await showDialog<bool>(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Delete Tracker'),
        content: Text('Are you sure you want to delete ${tracker.name}?'),
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
    }) ?? false;
    if (result) {
      widget.provider.removeTracker(tracker);
    }
  }

  String _amountAsCurrency(double amount, Currency currency) {
    final currencyFormat = NumberFormat.simpleCurrency(name: currency.code);
    return currencyFormat.format(amount);
  }
}
