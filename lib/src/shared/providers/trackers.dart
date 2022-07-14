import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../classes/tracker.dart';

class TrackersProvider extends ValueNotifier<List<Tracker>> {
  TrackersProvider(User user)
      : _trackersCollection =
            FirebaseFirestore.instance.collection('users/${user.uid}/trackers'),
        super([]) {
    _fetchTrackers();
  }

  Future<void> _fetchTrackers() async {
    _trackers =
        await _trackersCollection.get().then((event) => event.docs.map((e) {
              final String id = e.id;
              final Map<String, dynamic> data =
                  e.data() as Map<String, dynamic>;
              data['id'] = id;
              return Tracker.fromMap(data);
            }).toList());
    notifyListeners();
  }

  String get path => _trackersCollection.path;

  final CollectionReference _trackersCollection;
  late Stream<List<Tracker>> _trackers$;
  List<Tracker> _trackers = [];

  Stream<List<Tracker>> get trackers$ => _trackers$;

  @override
  List<Tracker> get value => _trackers;

  Future<void> addTracker(Tracker tracker) async {
    _trackersCollection.add(tracker.toMap());
    await _fetchTrackers();
  }

  Future<void> removeTracker(Tracker tracker) async {
    _trackersCollection.doc(tracker.id).delete();
    await _fetchTrackers();
  }

  Future<void> updateTracker(Tracker tracker) async {
    await _trackersCollection.doc(tracker.id).update(tracker.toMap());
    await _fetchTrackers();
  }

  Stream<Tracker> getTracker(String id) {
    return _trackersCollection.doc(id).snapshots().map((e) {
      final String id = e.id;
      final Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      data['id'] = id;
      return Tracker.fromMap(data);
    });
  }
}
