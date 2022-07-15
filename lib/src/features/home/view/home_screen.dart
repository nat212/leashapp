import 'package:flutter/material.dart';
import 'package:leashapp/src/features/home/view/tracker_list.dart';
import 'package:leashapp/src/features/trackers/trackers.dart';
import 'package:leashapp/src/shared/providers/trackers.dart';

import '../../../shared/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackers'),
        centerTitle: true,
      ),
      body: const TrackerList(),
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
    final result = await showDialog(
        context: context, builder: (context) => const AddTracker());
    if (result is Tracker) {
      TrackerProvider.instance.addTracker(
        name: result.name,
        amount: result.amount,
        description: result.description,
      );
    }
  }
}
