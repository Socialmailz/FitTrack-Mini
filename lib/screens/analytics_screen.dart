
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/data/activity_data.dart';
import 'package:myapp/models/activity.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  _buildHeader(textTheme),
                  const SizedBox(height: 20),
                  _buildSummaryCards(isWide),
                  const SizedBox(height: 30),
                  _buildChartCard(textTheme, isWide: isWide),
                  const SizedBox(height: 30),
                  _buildActivityBreakdown(textTheme),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Performance Analytics', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        _buildPeriodSelector(),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: DropdownButton<String>(
        value: _selectedPeriod,
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down, size: 20),
        items: _periods.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontSize: 14)),
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

  Widget _buildSummaryCards(bool isWide) {
    final summaryData = _getSummaryData();
    return GridView.count(
      crossAxisCount: isWide ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isWide ? 1.5 : 1.2,
      children: [
        _summaryCard(Icons.directions_run, 'Total Activities', summaryData['totalActivities']!.toStringAsFixed(0), Colors.orange),
        _summaryCard(Icons.route, 'Total Distance', '${summaryData['totalDistance']!.toStringAsFixed(1)} km', Colors.blue),
        _summaryCard(Icons.timer, 'Total Duration', _formatDuration(summaryData['totalDuration']!), Colors.green),
        _summaryCard(Icons.whatshot, 'Avg. Calories', '${summaryData['avgCalories']!.toStringAsFixed(0)} kcal', Colors.red),
      ],
    );
  }

  Widget _summaryCard(IconData icon, String title, String value, Color color) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
            const SizedBox(height: 12),
            Text(title, style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(value, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(TextTheme textTheme, {required bool isWide}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Distance Over Time', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(height: isWide ? 300 : 200, child: LineChart(_getLineChartData())),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityBreakdown(TextTheme textTheme) {
    final breakdownData = _getActivityBreakdown();
    if (breakdownData.isEmpty) return const SizedBox.shrink();

    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple, Colors.teal];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activity Breakdown', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ...breakdownData.entries.mapIndexed((index, entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(children: [Container(width: 12, height: 12, color: colors[index % colors.length]), const SizedBox(width: 8), Text('${entry.key}: ${entry.value.toStringAsFixed(1)} km')]),
                    );
                  })
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(height: 150, child: PieChart(_getPieChartData(breakdownData, colors))),
            ),
          ],
        ),
      ),
    );
  }

  // --- Data Processing Methods ---

  List<Activity> _getFilteredActivities() {
    final now = DateTime.now();
    return ActivityData.activities.where((act) {
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

  Map<String, double> _getSummaryData() {
    final filteredActivities = _getFilteredActivities();
    if (filteredActivities.isEmpty) {
      return {'totalActivities': 0, 'totalDistance': 0, 'totalDuration': 0, 'avgCalories': 0};
    }

    double totalDistance = filteredActivities.map((a) => a.distance).sum;
    double totalDuration = filteredActivities.map((a) => a.duration.inSeconds).sum.toDouble();
    // Simple calorie estimation: 60 kcal per km
    double totalCalories = totalDistance * 60;

    return {
      'totalActivities': filteredActivities.length.toDouble(),
      'totalDistance': totalDistance,
      'totalDuration': totalDuration, // in seconds
      'avgCalories': totalCalories / filteredActivities.length,
    };
  }

  Map<String, double> _getActivityBreakdown() {
    final filteredActivities = _getFilteredActivities();
    final data = <String, double>{};
    for (var activity in filteredActivities) {
      data.update(activity.type, (value) => value + activity.distance, ifAbsent: () => activity.distance);
    }
    return data;
  }

  LineChartData _getLineChartData() {
    final filteredActivities = _getFilteredActivities();
    final colorScheme = Theme.of(context).colorScheme;
    final spots = <FlSpot>[];

    final groupedData = groupBy(filteredActivities, (Activity act) {
      if (_selectedPeriod == 'Weekly' || _selectedPeriod == 'Monthly') {
        return DateFormat.E().format(act.timestamp); // Group by day of the week
      } else {
        return DateFormat.MMM().format(act.timestamp); // Group by month
      }
    });
    
    // This part is a simplification. A real implementation would need to handle x-axis labels and data points more robustly.
    // For this example, we just create some spots based on the number of groups.
    double i = 0;
    for (var group in groupedData.values) {
      double totalDistance = group.map((a) => a.distance).sum;
      spots.add(FlSpot(i, totalDistance));
      i++;
    }
    if (spots.isEmpty) spots.add(FlSpot.zero);

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: colorScheme.primary,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: true, color: colorScheme.primary.withOpacity(0.2)),
        ),
      ],
    );
  }


  PieChartData _getPieChartData(Map<String, double> breakdownData, List<Color> colors) {
    return PieChartData(
      sectionsSpace: 4,
      centerSpaceRadius: 40,
      sections: breakdownData.entries.mapIndexed((index, entry) {
        return PieChartSectionData(
          color: colors[index % colors.length],
          value: entry.value,
          title: '${(entry.value / breakdownData.values.sum * 100).toStringAsFixed(0)}%',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        );
      }).toList(),
    );
  }

  String _formatDuration(double totalSeconds) {
    final duration = Duration(seconds: totalSeconds.toInt());
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '$hours h ${minutes} m';
    } else {
      return '$minutes m';
    }
  }
}
