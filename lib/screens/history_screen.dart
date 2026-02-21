
import 'package:flutter/material.dart';
import 'package:myapp/widgets/ad_native.dart'; // Import the native ad widget

// Mock data model for a past activity
class Activity {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;

  Activity({required this.icon, required this.title, required this.subtitle, required this.trailing});
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Mock list of past activities
  final List<dynamic> _activityItems = [];
  List<dynamic> _filteredActivityItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Generate a mixed list of activities and ads
    _activityItems.addAll(generateMockActivities());
    insertAds();
    _filteredActivityItems = List.from(_activityItems);
    _searchController.addListener(_filterActivities);
  }

  List<Activity> generateMockActivities() {
    return [
      Activity(icon: Icons.directions_walk, title: 'Morning Walk', subtitle: '5,234 steps', trailing: '45 min'),
      Activity(icon: Icons.directions_run, title: 'Afternoon Run', subtitle: '3.5 km', trailing: '25 min'),
      Activity(icon: Icons.fitness_center, title: 'Gym Session', subtitle: '1.5 hours', trailing: '450 kcal'),
      Activity(icon: Icons.directions_bike, title: 'Evening Bike Ride', subtitle: '10 km', trailing: '40 min'),
      Activity(icon: Icons.pool, title: 'Swimming', subtitle: '30 laps', trailing: '60 min'),
      Activity(icon: Icons.hiking, title: 'Weekend Hike', subtitle: '8 km', trailing: '2.5 hours'),
      Activity(icon: Icons.directions_walk, title: 'Evening Stroll', subtitle: '3,120 steps', trailing: '30 min'),
       Activity(icon: Icons.directions_run, title: 'Morning Jog', subtitle: '2.1 km', trailing: '15 min'),
    ];
  }

  void insertAds() {
    // Insert an ad at a specific position in the list
    if (_activityItems.length > 3) {
      _activityItems.insert(3, const AdNative());
    }
     if (_activityItems.length > 7) {
      _activityItems.insert(7, const AdNative());
    }
  }

  void _filterActivities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredActivityItems = _activityItems.where((item) {
        if (item is Activity) {
          return item.title.toLowerCase().contains(query) || item.subtitle.toLowerCase().contains(query);
        }
        return true; // Always show ads
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ActivitySearchDelegate(_activityItems));
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter tap
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredActivityItems.length,
        itemBuilder: (context, index) {
          final item = _filteredActivityItems[index];
          if (item is Activity) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(item.icon, color: Theme.of(context).colorScheme.primary, size: 40),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item.subtitle),
                trailing: Text(item.trailing, style: TextStyle(color: Colors.grey[600])),
              ),
            );
          } else if (item is AdNative) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: item,
            ); // Render the native ad widget directly
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ActivitySearchDelegate extends SearchDelegate {
  final List<dynamic> _activityItems;

  ActivitySearchDelegate(this._activityItems);

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
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _activityItems.where((item) {
      if (item is Activity) {
        return item.title.toLowerCase().contains(query.toLowerCase()) || item.subtitle.toLowerCase().contains(query.toLowerCase());
      }
      return false;
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index] as Activity;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(item.icon, color: Theme.of(context).colorScheme.primary, size: 40),
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.subtitle),
            trailing: Text(item.trailing, style: TextStyle(color: Colors.grey[600])),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _activityItems.where((item) {
      if (item is Activity) {
        return item.title.toLowerCase().contains(query.toLowerCase());
      }
      return false;
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index] as Activity;
        return ListTile(
          title: Text(item.title),
          onTap: () {
            query = item.title;
            showResults(context);
          },
        );
      },
    );
  }
}
