import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';

class _TrackerListener extends ValueNotifier<TrackerProvider> {
  _TrackerListener(TrackerProvider provider) : super(provider);

  void notify() {
    notifyListeners();
  }
}

class TrackerProvider {
  static late final TrackerProvider _instance;

  late final Box<Tracker> _box;
  late final Box<Log> _logBox;
  late final _TrackerListener _listenable;

  TrackerProvider._internal(this._box, this._logBox) {
    _listenable = _TrackerListener(this);
    for (var element in trackers) {
      element.logs ??= HiveList<Log>(_logBox);
    }
    _box.listenable().addListener(() {
      _listenable.notify();
    });
  }

  static Future<void> initialise() async {
    final box = await Hive.openBox<Tracker>('trackers');
    final logBox = await Hive.openBox<Log>('logs');
    _instance = TrackerProvider._internal(box, logBox);
  }

  ValueListenable<TrackerProvider> get listenable => _listenable;

  static TrackerProvider get instance => _instance;

  Iterable<Tracker> get trackers => _box.values;

  void addTracker({
    required String name,
    String? description,
    required double amount,
  }) {
    final tracker = Tracker(
      name: name,
      description: description,
      amount: amount,
    );
    tracker.logs = HiveList(_logBox);
    _box.add(tracker);
  }

  Tracker? get(int key) {
    final tracker = _box.get(key);
    return tracker;
  }

  void addLog({required Tracker tracker, required Log log}) {
    _logBox.add(log);
    tracker.logs!.add(log);
    tracker.save();
  }

  Log? getLog(int logId) {
    return _logBox.get(logId);
  }
}
