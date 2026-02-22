
import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 2)
class UserSettings extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  String username;

  @HiveField(2)
  int dailyWaterGoal; // in ml

  UserSettings({
    this.isDarkMode = false,
    this.username = 'User',
    this.dailyWaterGoal = 2000,
  });
}
