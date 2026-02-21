
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/models/activity.dart';
import 'package:collection/collection.dart';
import 'package:myapp/services/database_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'Weekly';
  final List<String> _periods = ['Weekly', 'Monthly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ValueListenableBuilder<Box<Activity>>(
        valueListenable: DatabaseService.getActivitiesBox().listenable(),
        builder: (context, box, _) {
          final activities = box.values.toList().cast<Activity>();
          return LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(textTheme),
                    const SizedBox(height: 8),
                    _buildSummaryCards(isWide, activities),
                    const SizedBox(height: 24),
                    _buildChartCard(textTheme, isWide: isWide, activities: activities),
                    const SizedBox(height: 24),
                    _buildActivityBreakdown(textTheme, isWide: isWide, activities: activities),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Performance Analytics',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        _buildPeriodSelector(),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: DropdownButton<String>(
        value: _selectedPeriod,
        underline: Container(),
        icon: Icon(Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).colorScheme.primary),
        items: _periods.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedPeriod = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildSummaryCards(bool isWide, List<Activity> activities) {
    final summaryData = _getSummaryData(activities);
    return GridView.count(
      crossAxisCount: isWide ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isWide ? 1.6 : 1.3,
      children: [
        _summaryCard(Icons.local_fire_department_rounded, 'Total Activities',
            summaryData['totalActivities']!.toStringAsFixed(0), Colors.orange),
        _summaryCard(Icons.timeline_rounded, 'Total Distance',
            '${summaryData['totalDistance']!.toStringAsFixed(1)} km', Colors.blue),
        _summaryCard(Icons.timer_rounded, 'Total Duration',
            _formatDuration(summaryData['totalDuration']!), Colors.green),
        _summaryCard(Icons.whatshot_rounded, 'Avg. Calories',
            '${summaryData['avgCalories']!.toStringAsFixed(0)} kcal', Colors.red),
      ],
    );
  }

  Widget _summaryCard(IconData icon, String title, String value, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withAlpha(38),
              radius: 22,
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(TextTheme textTheme, {required bool isWide, required List<Activity> activities}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Distance Over Time',
                style: textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
                height: isWide ? 300 : 200, child: LineChart(_getLineChartData(activities))),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityBreakdown(TextTheme textTheme, {required bool isWide, required List<Activity> activities}) {
    final breakdownData = _getActivityBreakdown(activities);
    if (breakdownData.isEmpty) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const SizedBox(
          height: 200,
          child: Center(
              child: Text('No activity data available for this period.')),
        ),
      );
    }

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isWide
            ? Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: _buildBreakdownDetails(textTheme, breakdownData, colors)),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                        height: 180,
                        child: PieChart(_getPieChartData(breakdownData, colors))),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildBreakdownDetails(textTheme, breakdownData, colors),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: 150,
                      child: PieChart(_getPieChartData(breakdownData, colors))),
                ],
              ),
      ),
    );
  }

  Widget _buildBreakdownDetails(TextTheme textTheme,
      Map<String, double> breakdownData, List<Color> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Activity Breakdown',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ...breakdownData.entries.mapIndexed((index, entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    )),
                const SizedBox(width: 12),
                Text(
                  '${entry.key}: ${entry.value.toStringAsFixed(1)} km',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          );
        })
      ],
    );
  }

  List<Activity> _getFilteredActivities(List<Activity> allActivities) {
    final now = DateTime.now();
    return allActivities.where((act) {
      final difference = now.difference(act.timestamp).inDays;
      if (_selectedPeriod == 'Weekly') {
        return difference <= 7;
      } else if (_selectedPeriod == 'Monthly') {
        return difference <= 30;
      } else if (_selectedPeriod == 'Yearly') {
        return difference <= 365;
      }
      return false;
    }).toList();
  }

  Map<String, double> _getSummaryData(List<Activity> allActivities) {
    final filteredActivities = _getFilteredActivities(allActivities);
    if (filteredActivities.isEmpty) {
      return {
        'totalActivities': 0,
        'totalDistance': 0,
        'totalDuration': 0,
        'avgCalories': 0
      };
    }

    double totalDistance = filteredActivities.map((a) => a.distance).sum;
    double totalDuration =
        filteredActivities.map((a) => a.duration).sum.toDouble();
    double totalCalories = filteredActivities.map((a) => a.calories).sum.toDouble();

    return {
      'totalActivities': filteredActivities.length.toDouble(),
      'totalDistance': totalDistance,
      'totalDuration': totalDuration, // in minutes
      'avgCalories': filteredActivities.isEmpty
          ? 0
          : totalCalories / filteredActivities.length,
    };
  }

  Map<String, double> _getActivityBreakdown(List<Activity> allActivities) {
    final filteredActivities = _getFilteredActivities(allActivities);
    final data = <String, double>{};
    for (var activity in filteredActivities) {
      data.update(activity.type, (value) => value + activity.distance,
          ifAbsent: () => activity.distance);
    }
    return data;
  }

  LineChartData _getLineChartData(List<Activity> allActivities) {
    final filteredActivities = _getFilteredActivities(allActivities);
    final colorScheme = Theme.of(context).colorScheme;

    Map<int, double> dataMap = {};

    for (var act in filteredActivities) {
      int key;
      if (_selectedPeriod == 'Weekly') {
        key = act.timestamp.weekday; // 1 (Mon) to 7 (Sun)
      } else if (_selectedPeriod == 'Monthly') {
        key = act.timestamp.day;
      } else {
        key = act.timestamp.month;
      }
      dataMap.update(key, (value) => value + act.distance,
          ifAbsent: () => act.distance);
    }

    List<FlSpot> spots =
        dataMap.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
   
    if (spots.isEmpty) spots.add(FlSpot.zero);


    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withAlpha(25),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: const FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.3)],
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [colorScheme.primary.withOpacity(0.3), colorScheme.primary.withOpacity(0.0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  PieChartData _getPieChartData(
      Map<String, double> breakdownData, List<Color> colors) {
    return PieChartData(
      sectionsSpace: 4,
      centerSpaceRadius: 40,
      sections: breakdownData.entries.mapIndexed((index, entry) {
        final double percentage =
            (entry.value / breakdownData.values.sum * 100);
        return PieChartSectionData(
          color: colors[index % colors.length],
          value: entry.value,
          title: '${percentage.toStringAsFixed(0)}%',
          radius: 60,
          titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        );
      }).toList(),
    );
  }

  String _formatDuration(double totalMinutes) {
    final duration = Duration(minutes: totalMinutes.toInt());
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '$hours h $minutes m';
    } else {
      return '$minutes m';
    }
  }
}
