
import 'package:hive/hive.dart';

part 'daily_steps.g.dart';

@HiveType(typeId: 3)
class DailySteps extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  int steps;

  DailySteps({required this.date, required this.steps});
}
