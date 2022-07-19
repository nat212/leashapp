import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leashapp/src/features/home/view/tracker_card.dart';
import 'package:leashapp/src/shared/extensions.dart';

import '../../../shared/models/models.dart';
import '../../../shared/providers/trackers.dart';
import '../../../shared/widgets/clickable.dart';

enum TrackerSortMode {
  name,
  created,
}

enum TrackerSortDirection {
  ascending,
  descending,
}

class TrackerList extends StatefulWidget {
  const TrackerList({Key? key,
    required this.onTrackerTap,
    required this.onTrackerLongPress,
    this.selectedTrackers = const [],
    this.sortMode = TrackerSortMode.created,
    this.sortDirection = TrackerSortDirection.ascending})
      : super(key: key);

  final TrackerSortMode sortMode;
  final TrackerSortDirection sortDirection;
  final void Function(Tracker tracker) onTrackerTap;
  final void Function(Tracker tracker) onTrackerLongPress;
  final List<Tracker> selectedTrackers;

  @override
  State<TrackerList> createState() => _TrackerListState();
}

class _TrackerListState extends State<TrackerList> {
  int _compareTrackers(Tracker a, Tracker b) {
    switch (widget.sortMode) {
      case TrackerSortMode.name:
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case TrackerSortMode.created:
        return a.created.compareTo(b.created);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TrackerProvider>(
        valueListenable: TrackerProvider.instance.listenable,
        builder: (context, provider, child) {
          return provider.trackers.isNotEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    final unsortedTrackers = provider.trackers;
                    final trackers = unsortedTrackers.toList();
                    trackers.sort((a, b) => _compareTrackers(a, b));
                    return constraints.isMobile
                        ? ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              return _trackerCard(trackers[index], constraints);
                            },
                            itemCount: trackers.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16.0),
                          )
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
                              for (var tracker in trackers)
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
    return ValueListenableBuilder(
        valueListenable: (tracker.logs!.box as Box).listenable(),
        builder: (context, _, __) {
          return Clickable(
              onTap: () => widget.onTrackerTap(tracker),
              child: GestureDetector(
                  onLongPress: () => widget.onTrackerLongPress(tracker),
                  child: TrackerCard(
                    tracker: tracker,
                    constraints: constraints,
                    selected: widget.selectedTrackers.contains(tracker),
                  )));
        });
  }
}
