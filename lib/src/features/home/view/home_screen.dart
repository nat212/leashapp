import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leashapp/src/features/home/view/tracker_list.dart';
import 'package:leashapp/src/shared/models/models.dart';
import 'package:leashapp/src/shared/providers/trackers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TrackerSortMode _sortMode = TrackerSortMode.created;
  final TrackerSortDirection _sortDirection = TrackerSortDirection.ascending;
  bool _selectMode = false;
  List<Tracker> _selectedTrackers = [];

  AppBar _contextualAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '${_selectedTrackers.length} selected',
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedTrackers = [...TrackerProvider.instance.trackers];
            });
          },
          icon: const Icon(Icons.select_all),
          tooltip: 'Select all',
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _selectedTrackers = [];
            });
          },
          icon: const Icon(Icons.deselect),
          tooltip: 'Clear selection',
        ),
        IconButton(
            onPressed: _selectedTrackers.isEmpty
                ? null
                : () {
                    _deleteSelectedTrackers();
                  },
            icon: const Icon(Icons.delete))
      ],
      leading: IconButton(
        onPressed: () {
          _cancelSelection();
        },
        icon: const Icon(Icons.close),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Trackers'),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                _selectMode = true;
              });
            },
            icon: const Icon(Icons.checklist)),
        IconButton(
            onPressed: () async {
              final result = await showMenu<TrackerSortMode>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                      MediaQuery.of(context).size.width - 48,
                      MediaQuery.of(context).padding.top,
                      0,
                      0),
                  items: [
                    const PopupMenuItem(
                      value: TrackerSortMode.name,
                      child: Text('Sort by name'),
                    ),
                    const PopupMenuItem(
                      value: TrackerSortMode.created,
                      child: Text('Sort by creation date'),
                    ),
                  ]);
              if (result != null) {
                setState(() {
                  _sortMode = result;
                });
              }
            },
            icon: const Icon(Icons.sort)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectMode ? _contextualAppBar(context) : _buildAppBar(context),
      body: TrackerList(
        sortDirection: _sortDirection,
        sortMode: _sortMode,
        onTrackerTap: _onTrackerTap,
        onTrackerLongPress: _onTrackerLongPress,
        selectedTrackers: _selectedTrackers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        onPressed: () {
          _addTracker();
        },
        label: const Text('Add Tracker'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteSelectedTrackers() async {
    final bool? result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Delete')),
              ],
              title: const Text('Delete Trackers'),
              content: Text(
                  'Are you sure you want to delete the ${_selectedTrackers.length} selected trackers?'),
            ));
    if (result ?? false) {
      for (var tracker in _selectedTrackers) {
        tracker.delete();
      }
      _cancelSelection();
    }
  }

  void _cancelSelection() {
    setState(() {
      _selectMode = false;
      _selectedTrackers = [];
    });
  }

  void _addTracker() async {
    context.go('/trackers/add');
  }

  void _onTrackerLongPress(Tracker tracker) {
    setState(() {
      _selectMode = true;
      _selectedTrackers = [tracker];
    });
  }

  void _onTrackerTap(Tracker tracker) {
    if (_selectMode) {
      setState(() {
        if (_selectedTrackers.contains(tracker)) {
          _selectedTrackers.remove(tracker);
          tracker.selected = false;
        } else {
          _selectedTrackers.add(tracker);
          tracker.selected = true;
        }
      });
    } else {
      context.go('/trackers/${tracker.key}');
    }
  }
}
