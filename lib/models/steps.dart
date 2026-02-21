
import 'package:hive/hive.dart';

part 'steps.g.dart';

@HiveType(typeId: 1)
class Steps extends HiveObject {
  @HiveField(0)
  int count;

  @HiveField(1)
  DateTime date;

  Steps({
    required this.count,
    required this.date,
  });
}
