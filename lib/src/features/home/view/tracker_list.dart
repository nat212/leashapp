import 'package:flutter/material.dart';
import 'package:leashapp/src/features/home/view/tracker_card.dart';

import '../../../shared/classes/tracker.dart';
import '../../../shared/providers/trackers.dart';

class TrackerList extends StatefulWidget {
  const TrackerList({Key? key, required this.trackersProvider})
      : super(key: key);

  final TrackersProvider trackersProvider;

  @override
  State<TrackerList> createState() => _TrackerListState();
}

class _TrackerListState extends State<TrackerList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Tracker>>(
        valueListenable: widget.trackersProvider,
        builder: (context, trackers, child) {
          return trackers.isNotEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      // childAspectRatio: constraints.maxWidth < 400 ? 1.5 : 1.2,
                      crossAxisCount: constraints.maxWidth < 400
                          ? 1
                          : constraints.maxWidth < 800
                              ? 3
                              : constraints.maxWidth < 1200
                                  ? 4
                                  : 5,
                      children: [
                        for (var tracker in trackers)
                          TrackerCard(
                              tracker: tracker,
                              provider: widget.trackersProvider),
                      ],
                    );
                  },
                )
              : const Center(
                  child: Text(
                      'You have no trackers. Press the + button at the bottom right to add one.'),
                );
        });
  }
}
