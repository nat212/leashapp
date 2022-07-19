import 'package:currency_picker/currency_picker.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:leashapp/src/shared/extensions.dart';
import 'package:leashapp/src/shared/models/models.dart';

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

  @HiveField(4)
  late HiveList<Log>? logs;

  bool selected = false;

  double get totalSpent => logs!.map((e) => e.amount).sum();

  double get remaining => amount - totalSpent;

  double get percentageSpent => totalSpent / amount;

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

  void addLog(Log log) {
    logs!.add(log);
  }
}

extension FormatCurrency on Currency {
  String format(num amount) {
    final formatter = NumberFormat.simpleCurrency(name: code);
    return formatter.format(amount);
  }
}
