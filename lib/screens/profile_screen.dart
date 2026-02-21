
import 'package:flutter/material.dart';
import 'package:myapp/data/activity_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final totalActivities = ActivityData.activities.length;
    final totalDistance = ActivityData.activities.fold(0.0, (sum, item) => sum + item.distance);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 65,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'), // Placeholder image
              ),
            ),
            const SizedBox(height: 20),
            Text('Alex Doe', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('alex.doe@example.com', style: textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 40),
            const Divider(),
            _buildStatCard(textTheme, colorScheme, Icons.calendar_today, 'Joined', 'January 2024'),
            const Divider(),
            _buildStatCard(textTheme, colorScheme, Icons.directions_run, 'Total Activities', totalActivities.toString()),
            const Divider(),
            _buildStatCard(textTheme, colorScheme, Icons.map_outlined, 'Total Distance', '${totalDistance.toStringAsFixed(2)} km'),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(TextTheme textTheme, ColorScheme colorScheme, IconData icon, String label, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      leading: Icon(icon, color: colorScheme.primary, size: 30),
      title: Text(label, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      trailing: Text(
        value,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.secondary,
        ),
      ),
    );
  }
}
