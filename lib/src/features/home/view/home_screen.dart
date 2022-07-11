import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leashapp/src/features/home/view/tracker_list.dart';
import 'package:leashapp/src/features/trackers/trackers.dart';
import 'package:leashapp/src/shared/classes/tracker.dart';
import 'package:leashapp/src/shared/providers/trackers.dart';

import '../../../shared/providers/auth.dart';
import '../../../shared/views/loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User?>(
      builder: (context, value, child) {
        if (value != null) {
          final trackersProvider = TrackersProvider(value);
          return Scaffold(
              body: TrackerList(
            trackersProvider: trackersProvider,
          ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _addTracker(trackersProvider);
              },
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return const Loader();
        }
      },
      valueListenable: AuthProvider.instance,
    );
  }

  void _addTracker(TrackersProvider trackersProvider) async {
    final result = await showDialog(context: context, builder: (context) => const AddTracker());
    if (result is Tracker) {
      await trackersProvider.addTracker(result);
    }
  }
}
