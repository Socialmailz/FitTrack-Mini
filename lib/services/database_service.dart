
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:myapp/models/user_settings.dart';
import 'package:myapp/models/water.dart';
import 'package:path_provider/path_provider.dart';

import '../models/activity.dart';
import '../models/steps.dart';

class DatabaseService {
  static const String activitiesBoxName = 'activities';
  static const String stepsBoxName = 'steps';
  static const String settingsBoxName = 'settings';
  static const String waterBoxName = 'water';

  static Future<void> initDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(StepsAdapter());
    Hive.registerAdapter(UserSettingsAdapter());
    Hive.registerAdapter(WaterAdapter());

    await Hive.openBox<Activity>(activitiesBoxName);
    await Hive.openBox<Steps>(stepsBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox<Water>(waterBoxName);
  }

  // Settings
  Box get _settingsBox => Hive.box(settingsBoxName);

  UserSettings get userSettings {
    final settings = _settingsBox.get('user_settings');
    if (settings == null) {
      final defaultSettings = UserSettings();
      _settingsBox.put('user_settings', defaultSettings);
      return defaultSettings;
    }
    return settings as UserSettings;
  }

  Future<void> saveUserSettings(UserSettings settings) async {
    await _settingsBox.put('user_settings', settings);
  }

  // Activities
  static Box<Activity> getActivitiesBox() {
    return Hive.box<Activity>(activitiesBoxName);
  }

  Future<void> addActivity(Activity activity) async {
    await getActivitiesBox().add(activity);
  }

  List<Activity> getActivities() {
    return getActivitiesBox().values.toList();
  }
  
  Future<void> deleteActivity(dynamic key) async {
    await getActivitiesBox().delete(key);
  }

  // Steps
  Box<Steps> get _stepsBox => Hive.box<Steps>(stepsBoxName);

  Future<void> saveSteps(Steps steps) async {
    final existingEntry = _stepsBox.values.firstWhereOrNull(
        (s) =>
            s.date.year == steps.date.year &&
            s.date.month == steps.date.month &&
            s.date.day == steps.date.day);

    if (existingEntry != null) {
      existingEntry.count = steps.count;
      await _stepsBox.put(existingEntry.key, steps);
    } else {
      await _stepsBox.add(steps);
    }
  }

  Steps getStepsForDay(DateTime date) {
    return _stepsBox.values.firstWhere(
        (s) =>
            s.date.year == date.year &&
            s.date.month == date.month &&
            s.date.day == date.day,
        orElse: () => Steps(count: 0, date: date));
  }

  // Water
  static Box<Water> getWaterBox() {
    return Hive.box<Water>(waterBoxName);
  }

  Water getWaterForDay(DateTime date) {
    return getWaterBox().values.firstWhere(
        (w) =>
            w.date.year == date.year &&
            w.date.month == date.month &&
            w.date.day == date.day,
        orElse: () => Water(milliliters: 0, date: date));
  }

  Future<void> saveWater(Water water) async {
    final existingEntry = getWaterBox().values.firstWhereOrNull(
        (w) =>
            w.date.year == water.date.year &&
            w.date.month == water.date.month &&
            w.date.day == water.date.day);

    if (existingEntry != null) {
      existingEntry.milliliters = water.milliliters;
      await getWaterBox().put(existingEntry.key, water);
    } else {
      await getWaterBox().add(water);
    }
  }

  Future<void> deleteAllData() async {
    await getActivitiesBox().clear();
    await _stepsBox.clear();
    await _settingsBox.clear();
    await getWaterBox().clear();
  }
}
