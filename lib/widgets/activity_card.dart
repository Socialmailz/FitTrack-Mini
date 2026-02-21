
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.directions_run), // Dynamic icon based on activity type
        title: Text(activity.type),
        subtitle: Text('${activity.duration} mins - ${activity.calories} kcal'),
        trailing: Text(DateFormat.yMMMd().format(activity.timestamp)),
      ),
    );
  }
}
