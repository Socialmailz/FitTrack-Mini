
import 'package:myapp/models/activity.dart';

class ActivityData {
  static final List<Activity> _activities = [];

  static List<Activity> get activities => _activities;

  static void addActivity(Activity activity) {
    _activities.add(activity);
  }
}
