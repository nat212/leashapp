import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leashapp/src/features/home/view/tracker_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TrackerSortMode _sortMode = TrackerSortMode.created;
  TrackerSortDirection _sortDirection = TrackerSortDirection.ascending;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackers'),
        centerTitle: true,
        actions: [
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
      ),
      body: TrackerList(
        sortDirection: _sortDirection,
        sortMode: _sortMode,
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

  void _addTracker() async {
    context.go('/trackers/add');
  }
}
