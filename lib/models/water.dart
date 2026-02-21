
import 'package:hive/hive.dart';

part 'water.g.dart';

@HiveType(typeId: 3)
class Water extends HiveObject {
  @HiveField(0)
  int milliliters;

  @HiveField(1)
  final DateTime date;

  Water({required this.milliliters, required this.date});
}
