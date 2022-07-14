
import 'package:hive/hive.dart';

import 'types.dart';

part 'log.g.dart';

@HiveType(typeId: logType)
class Log extends HiveObject {
  @HiveField(0)
  final DateTime created;

  @HiveField(1)
  String label;

  @HiveField(2)
  double amount;

  Log({
    required this.label,
    required this.amount,
  }) : created = DateTime.now();
}