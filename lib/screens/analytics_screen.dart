
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/data/activity_data.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late Map<String, double> activityData;

  @override
  void initState() {
    super.initState();
    _prepareChartData();
  }

  void _prepareChartData() {
    final activities = ActivityData.activities;
    final data = <String, double>{};
    for (var activity in activities) {
      data.update(activity.type, (value) => value + activity.distance, ifAbsent: () => activity.distance);
    }
    setState(() {
      activityData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Analytics', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
      ),
      body: activityData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    'Not Enough Data',
                    style: textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track some activities to see your analytics!',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Distance by Activity',
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: _calculateMaxY(),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: colorScheme.secondary.withOpacity(0.8),
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: _bottomTitles,
                              reservedSize: 38,
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _generateBarGroups(colorScheme),
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  double _calculateMaxY() {
    if (activityData.isEmpty) return 0;
    final maxDistance = activityData.values.reduce((a, b) => a > b ? a : b);
    return maxDistance * 1.25; // Add 25% padding for better visualization
  }

  List<BarChartGroupData> _generateBarGroups(ColorScheme colorScheme) {
    return List.generate(activityData.length, (index) {
      final type = activityData.keys.elementAt(index);
      final distance = activityData[type]!;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: distance,
            color: colorScheme.primary,
            width: 22,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    });
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    final textTheme = Theme.of(context).textTheme;
    final type = activityData.keys.elementAt(value.toInt());
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Text(type, style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
