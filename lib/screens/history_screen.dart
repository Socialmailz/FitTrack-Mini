
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/models/activity.dart';
import 'package:myapp/services/database_service.dart';
import 'package:myapp/widgets/activity_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final activities = DatabaseService.getActivitiesBox().values.toList().cast<Activity>();
              showSearch(context: context, delegate: ActivitySearchDelegate(activities));
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Activity>>(
        valueListenable: DatabaseService.getActivitiesBox().listenable(),
        builder: (context, box, _) {
          final activities = box.values.toList().cast<Activity>();
          if (activities.isEmpty) {
            return const Center(
              child: Text('No activities recorded yet.'),
            );
          }
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[activities.length - 1 - index]; // Show newest first
              return ActivityCard(activity: activity);
            },
          );
        },
      ),
    );
  }
}

class ActivitySearchDelegate extends SearchDelegate<Activity> {
  final List<Activity> activities;

  ActivitySearchDelegate(this.activities);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Activity(type: '', duration: 0, calories: 0, distance: 0, timestamp: DateTime.now()));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = activities.where((activity) => activity.type.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ActivityCard(activity: results[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = activities.where((activity) => activity.type.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].type),
          onTap: () {
            query = suggestions[index].type;
            showResults(context);
          },
        );
      },
    );
  }
}
