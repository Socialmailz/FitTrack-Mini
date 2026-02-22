
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/models/activity.dart';
import 'package:myapp/models/user_settings.dart';
import 'package:myapp/models/water.dart';
import 'package:myapp/services/database_service.dart';
import 'package:myapp/services/step_service.dart';
import 'package:myapp/widgets/activity_card.dart';
import 'package:myapp/widgets/home_header.dart';
import 'package:myapp/widgets/metric_card.dart';
import 'package:myapp/widgets/water_card.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late Water _todayWater;
  late UserSettings _userSettings;
  late StepService _stepService;
  int _todaySteps = 0;
  double _todayDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _userSettings = Hive.box<UserSettings>(DatabaseService.userSettingsBoxName).get(0)!;
    _todayWater = _databaseService.getWaterForDay(DateTime.now());
    _stepService = Provider.of<StepService>(context, listen: false);
    _stepService.stepCountStream.listen((steps) {
      if (mounted) {
        setState(() {
          _todaySteps = steps;
        });
      }
    });
    _stepService.distanceStream.listen((distance) {
      if (mounted) {
        setState(() {
          _todayDistance = distance;
        });
      }
    });
  }

  void _addWater() {
    setState(() {
      _todayWater.milliliters += 250;
    });
    _databaseService.saveWater(_todayWater);
  }

  void _resetWater() {
    setState(() {
      _todayWater.milliliters = 0;
    });
    _databaseService.saveWater(_todayWater);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(title: 'Hello!', subtitle: 'Welcome back to your health dashboard.'),
                const SizedBox(height: 20),
                _buildMetrics(),
                const SizedBox(height: 20),
                ValueListenableBuilder<Box<Water>>(
                  valueListenable: DatabaseService.getWaterBox().listenable(),
                  builder: (context, box, _) {
                    _todayWater = _databaseService.getWaterForDay(DateTime.now());
                    return WaterCard(
                      waterIntake: _todayWater.milliliters,
                      waterGoal: _userSettings.dailyWaterGoal,
                      onAddWater: _addWater,
                      onResetWater: _resetWater,
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildRecentActivities(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Progress',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: 'Steps',
                value: '$_todaySteps',
                icon: Icons.directions_walk,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: MetricCard(
                title: 'Calories',
                value: '320 kcal',
                icon: Icons.local_fire_department,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: MetricCard(
                title: 'Active Time',
                value: '45 min',
                icon: Icons.timer,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MetricCard(
                title: 'Distance',
                value: '${_todayDistance.toStringAsFixed(2)} km',
                icon: Icons.route,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<Box<Activity>>(
          valueListenable: DatabaseService.getActivitiesBox().listenable(),
          builder: (context, box, _) {
            final activities = box.values.toList().cast<Activity>();
            if (activities.isEmpty) {
              return const Center(
                child: Text('No recent activities.'),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length > 3 ? 3 : activities.length,
              itemBuilder: (context, index) {
                final activity = activities[activities.length - 1 - index];
                return ActivityCard(activity: activity);
              },
            );
          },
        ),
      ],
    );
  }
}
