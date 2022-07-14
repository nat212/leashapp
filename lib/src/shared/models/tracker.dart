import 'package:hive/hive.dart';

import 'types.dart';

part 'tracker.g.dart';

@HiveType(typeId: trackerType)
class Tracker extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? description;

  @HiveField(2)
  double amount;

  @HiveField(3)
  final DateTime created;

  Tracker({
    required this.name,
    this.description,
    required this.amount,
  }) : created = DateTime.now();

  Tracker update({
  String? name,
    String? description,
    double? amount,
}) {
    this.name = name ?? this.name;
    this.description = description ?? this.description;
    this.amount = amount ?? this.amount;
    return this;
  }
}
