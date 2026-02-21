
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:countup/countup.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/widgets/ad_banner.dart'; // Import AdBanner

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // --- Mock Data ---
  final String userName = "Alex";
  final int stepGoal = 10000;
  final int currentSteps = 7865;
  final double caloriesBurned = 350.7;
  final double distanceCovered = 5.9;
  final int activeMinutes = 52;
  final Map<int, int> weeklySteps = { 0: 8765, 1: 6543, 2: 7890, 3: 9876, 4: 5432, 5: 11234, 6: 7865 };
  final double waterGoal = 2000; // 2000 ml
  double currentWater = 750;
  final int weeklyStreak = 3;

  final List<String> motivationalQuotes = [
    "The only bad workout is the one that didn't happen.",
    "Your body can stand almost anything. It’s your mind that you have to convince.",
    "Success isn’t always about greatness. It’s about consistency.",
    "The journey of a thousand miles begins with a single step."
  ];

  String _getGreeting() => DateTime.now().hour < 12 ? 'Good Morning' : (DateTime.now().hour < 17 ? 'Good Afternoon' : 'Good Evening');
  String _getTodaysDate() => DateFormat('EEEE, d MMMM').format(DateTime.now());
  String _getMotivationalQuote() => motivationalQuotes[DateTime.now().day % motivationalQuotes.length];

  void _addWater() {
    setState(() {
      currentWater += 250;
      if (currentWater > waterGoal) currentWater = waterGoal;
    });
  }

  void _resetWater() {
    setState(() {
      currentWater = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _buildAppBar(colorScheme),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: [
          _buildWelcomeSection(textTheme, colorScheme),
          const SizedBox(height: 24),
          _buildDailySummaryCard(textTheme, colorScheme),
          const SizedBox(height: 24),
          _buildQuickStartButtons(textTheme, colorScheme),
          const SizedBox(height: 24),
          _buildWeeklyProgressCard(textTheme, colorScheme),
          const SizedBox(height: 24),
          _buildWaterIntakeCard(textTheme, colorScheme),
          const SizedBox(height: 24),
          _buildAchievementsCard(textTheme, colorScheme),
          const SizedBox(height: 24),
          const AdBanner(), // AdMob Banner
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  AppBar _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      leadingWidth: 40,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Image.asset('assets/logo.png', color: colorScheme.primary),
      ),
      title: const Text('FitTrack Mini', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none_outlined, size: 28), onPressed: () {}),
        IconButton(icon: const Icon(Icons.settings_outlined, size: 28), onPressed: () {}),
        const SizedBox(width: 12),
      ],
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: colorScheme.onSurface,
    );
  }

  Widget _buildWelcomeSection(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${_getGreeting()}, $userName!', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(_getTodaysDate(), style: textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Text('"${_getMotivationalQuote()}"', style: textTheme.titleSmall?.copyWith(fontStyle: FontStyle.italic, color: colorScheme.primary.withOpacity(0.9)), textAlign: TextAlign.center),
        )
      ],
    );
  }

  Widget _buildDailySummaryCard(TextTheme textTheme, ColorScheme colorScheme) {
    final double stepProgress = (currentSteps / stepGoal).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 15.0,
              percent: stepProgress,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: colorScheme.surface.withOpacity(0.5),
              progressColor: colorScheme.primary,
              animation: true,
              animationDuration: 1200,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
                    children: [
                      Countup(begin: 0, end: currentSteps.toDouble(), duration: const Duration(milliseconds: 1200), separator: ',', style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                      Text(' steps', style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary)),
                    ],
                  ),
                  Text('Goal: ${NumberFormat.decimalPattern().format(stepGoal)}', style: textTheme.titleSmall?.copyWith(color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(textTheme, colorScheme, Icons.local_fire_department, '${caloriesBurned.toStringAsFixed(0)} kcal', 'Calories'),
                _statItem(textTheme, colorScheme, Icons.route, '${distanceCovered.toStringAsFixed(1)} km', 'Distance'),
                _statItem(textTheme, colorScheme, Icons.timer, '$activeMinutes min', 'Active Time'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(TextTheme textTheme, ColorScheme colorScheme, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: colorScheme.secondary, size: 30),
        const SizedBox(height: 8),
        Text(value, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildQuickStartButtons(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Start', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.5,
          children: [
            _quickStartWorkoutButton(Icons.directions_walk, 'Start Walk'),
            _quickStartWorkoutButton(Icons.directions_run, 'Start Run'),
            _quickStartWorkoutButton(Icons.directions_bike, 'Start Cycling'),
            _quickStartWorkoutButton(Icons.fitness_center, 'Custom Workout'),
          ],
        ),
      ],
    );
  }

  Widget _quickStartWorkoutButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 28),
      label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Theme.of(context).cardColor, foregroundColor: Theme.of(context).colorScheme.onSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget _buildWeeklyProgressCard(TextTheme textTheme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Weekly Progress", style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(height: 150, child: BarChart(_buildBarChartData(colorScheme), swapAnimationDuration: const Duration(milliseconds: 450), swapAnimationCurve: Curves.easeInOutSine)),
            const SizedBox(height: 16),
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('View Detailed Stats →')))
          ],
        ),
      ),
    );
  }

  BarChartData _buildBarChartData(ColorScheme colorScheme) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: (weeklySteps.values.reduce((a,b) => a > b ? a : b) * 1.2).toDouble(),
      barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem((rod.toY - 1).toStringAsFixed(0), const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
      titlesData: FlTitlesData(show: true, topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (double value, TitleMeta meta) {
        const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
        String text; switch (value.toInt()) { case 0: text = 'M'; break; case 1: text = 'T'; break; case 2: text = 'W'; break; case 3: text = 'T'; break; case 4: text = 'F'; break; case 5: text = 'S'; break; case 6: text = 'S'; break; default: text = ''; break; }
        return SideTitleWidget(child: Text(text, style: style), axisSide: meta.axisSide);
      }))),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      barGroups: weeklySteps.entries.map((entry) => BarChartGroupData(x: entry.key, barRods: [BarChartRodData(toY: entry.value.toDouble(), color: entry.key == DateTime.now().weekday - 1 ? colorScheme.primary : colorScheme.secondary, width: 20, borderRadius: BorderRadius.circular(6))])).toList(),
    );
  }

  Widget _buildWaterIntakeCard(TextTheme textTheme, ColorScheme colorScheme) {
    double waterProgress = (currentWater / waterGoal).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Water Intake', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)), Text('${currentWater.toStringAsFixed(0)} / ${waterGoal.toStringAsFixed(0)} ml', style: textTheme.titleMedium)]),
            const SizedBox(height: 16),
            LinearPercentIndicator(percent: waterProgress, lineHeight: 20.0, barRadius: const Radius.circular(10), progressColor: colorScheme.primary, backgroundColor: colorScheme.primary.withOpacity(0.2), animation: true, animationDuration: 1000),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ElevatedButton.icon(onPressed: _addWater, icon: const Icon(Icons.add), label: const Text("Add 250ml")), TextButton(onPressed: _resetWater, child: const Text('Reset'))])
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard(TextTheme textTheme, ColorScheme colorScheme) {
    bool goalAchieved = currentSteps >= stepGoal;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _achievementItem(textTheme, colorScheme, goalAchieved ? colorScheme.secondary : Colors.grey, Icons.check_circle, 'Daily Goal', goalAchieved ? 'Achieved!' : 'Keep Going'),
            _achievementItem(textTheme, colorScheme, colorScheme.secondary, Icons.local_fire_department, 'Weekly Streak', '$weeklyStreak Days'),
            _achievementItem(textTheme, colorScheme, Colors.grey, Icons.star_border, 'New Badge', 'Coming Soon'),
          ],
        ),
      ),
    );
  }

  Widget _achievementItem(TextTheme textTheme, ColorScheme colorScheme, Color iconColor, IconData icon, String label, String status) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 40),
        const SizedBox(height: 8),
        Text(label, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(status, style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
      ],
    );
  }
}
