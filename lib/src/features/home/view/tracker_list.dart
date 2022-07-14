import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:leashapp/src/features/home/view/tracker_card.dart';
import 'package:leashapp/src/shared/extensions.dart';

import '../../../shared/models/models.dart';
import '../../../shared/providers/trackers.dart';
import '../../../shared/widgets/clickable.dart';

class TrackerList extends StatefulWidget {
  const TrackerList({Key? key})
      : super(key: key);

  @override
  State<TrackerList> createState() => _TrackerListState();
}

class _TrackerListState extends State<TrackerList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Tracker>>(
        valueListenable: TrackerProvider.instance.listenable,
        builder: (context, trackers, child) {
          return trackers.isNotEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return constraints.isMobile
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (var tracker in trackers.values) ...[
                                  _trackerCard(tracker, constraints),
                                  if (tracker != trackers.values.last)
                                    const SizedBox(height: 16.0),
                                ],
                              ],
                            ))
                        : GridView.count(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(20),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.5,
                            crossAxisCount: constraints.isMobile
                                ? 1
                                : constraints.maxWidth < 800
                                    ? 3
                                    : constraints.maxWidth < 1200
                                        ? 4
                                        : 5,
                            children: [
                              for (var tracker in trackers.values)
                                _trackerCard(tracker, constraints),
                            ],
                          );
                  },
                )
              : const Center(
                  child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      'You have no trackers. Press the + button at the bottom right to add one.'),
                ));
        });
  }

  Widget _trackerCard(Tracker tracker, BoxConstraints constraints) {
    return Clickable(
        onTap: () => GoRouter.of(context)
            .go('/trackers/${tracker.key}'),
        child: TrackerCard(
          tracker: tracker,
          constraints: constraints,
        ));
  }
}
