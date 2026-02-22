
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
  static const String userSettingsBoxName = 'settings';
  static const String waterBoxName = 'water';

  static const String userSettingsKey = 'user_settings';

  static Future<void> initDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Register adapters if they haven't been registered yet
    if (!Hive.isAdapterRegistered(ActivityAdapter().typeId)) {
      Hive.registerAdapter(ActivityAdapter());
    }
    if (!Hive.isAdapterRegistered(StepsAdapter().typeId)) {
      Hive.registerAdapter(StepsAdapter());
    }
    if (!Hive.isAdapterRegistered(UserSettingsAdapter().typeId)) {
      Hive.registerAdapter(UserSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(WaterAdapter().typeId)) {
      Hive.registerAdapter(WaterAdapter());
    }

    await Hive.openBox<Activity>(activitiesBoxName);
    await Hive.openBox<Steps>(stepsBoxName);
    await Hive.openBox<UserSettings>(userSettingsBoxName);
    await Hive.openBox<Water>(waterBoxName);

    // --- The Permanent Fix ---
    // Ensure that a UserSettings object always exists.
    final settingsBox = getUserSettingsBox();
    if (settingsBox.get(userSettingsKey) == null) {
      await settingsBox.put(userSettingsKey, UserSettings());
    }
  }

  // --- Settings ---
  // Static method to get the settings box for easy access from anywhere in the app.
  static Box<UserSettings> getUserSettingsBox() {
    return Hive.box<UserSettings>(userSettingsBoxName);
  }

  // --- Activities ---
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

  // --- Steps ---
  Box<Steps> get _stepsBox => Hive.box<Steps>(stepsBoxName);

  Future<void> saveSteps(Steps steps) async {
    final existingEntry = _stepsBox.values.firstWhereOrNull(
        (s) =>
            s.date.year == steps.date.year &&
            s.date.month == steps.date.month &&
            s.date.day == steps.date.day);

    if (existingEntry != null) {
      existingEntry.count = steps.count;
      await _stepsBox.put(existingEntry.key, existingEntry);
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

  // --- Water ---
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
    final box = getWaterBox();
    final existingEntry = box.values.firstWhereOrNull((w) => w.date.isAtSameMomentAs(water.date));

    if (existingEntry != null) {
      // If an entry for the date exists, update it.
      // Assuming Water object has a key property managed by Hive.
      await box.put(existingEntry.key, water);
    } else {
      // If no entry exists for the date, add a new one.
      await box.add(water);
    }
  }

  Future<void> deleteAllData() async {
    await getActivitiesBox().clear();
    await Hive.box(stepsBoxName).clear();
    await getWaterBox().clear();
    
    // Also clear the settings box but immediately re-initialize it.
    final settingsBox = getUserSettingsBox();
    await settingsBox.clear();
    await settingsBox.put(userSettingsKey, UserSettings());
  }
}
