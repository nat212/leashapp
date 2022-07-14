import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';

class TrackerProvider {
  static late final TrackerProvider _instance;

  late final Box<Tracker> _box;

  TrackerProvider._internal(this._box);

  static Future<void> initialise() async {
    final box = await Hive.openBox<Tracker>('trackers');
    _instance = TrackerProvider._internal(box);
  }

  ValueListenable<Box<Tracker>> get listenable => _box.listenable();

  static TrackerProvider get instance => _instance;

  void addTracker({
    required String name,
    String? description,
    required double amount,
  }) {
    _box.add(Tracker(
      name: name,
      description: description,
      amount: amount,
    ));
  }

  Tracker? get(dynamic key) {
    return _box.get(key);
  }
}
