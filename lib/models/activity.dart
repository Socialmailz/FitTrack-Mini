
import 'package:hive/hive.dart';

part 'activity.g.dart';

@HiveType(typeId: 0)
class Activity extends HiveObject {
  @HiveField(0)
  final String type;

  @HiveField(1)
  final int duration; // in minutes

  @HiveField(2)
  final int calories;

  @HiveField(3)
  final double distance;

  @HiveField(4)
  final DateTime timestamp;

  Activity({
    required this.type,
    required this.duration,
    required this.calories,
    required this.distance,
    required this.timestamp,
  });
}
