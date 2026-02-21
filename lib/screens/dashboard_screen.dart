
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myapp/services/step_service.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:countup/countup.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/widgets/ad_banner.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String userName = "Alex";
  final int stepGoal = 10000;
  int _currentSteps = 7865;
  final double caloriesBurned = 350.7;
  final double distanceCovered = 5.9;
  final int activeMinutes = 52;
  final Map<int, int> weeklySteps = {
    0: 8765,
    1: 6543,
    2: 7890,
    3: 9876,
    4: 5432,
    5: 11234,
    6: 7865
  };
  final double waterGoal = 2000;
  double currentWater = 750;
  final int weeklyStreak = 3;

  final List<String> motivationalQuotes = [
    "The only bad workout is the one that didn't happen.",
    "Your body can stand almost anything. It’s your mind that you have to convince.",
    "Success isn’t always about greatness. It’s about consistency.",
    "The journey of a thousand miles begins with a single step."
  ];

  late final StepService _stepService;

  @override
  void initState() {
    super.initState();
    _stepService = StepService();
    _stepService.init();
    _stepService.stepCountStream.listen((stepCount) {
      setState(() {
        _currentSteps = stepCount.steps;
      });
    });
  }

  String _getGreeting() => DateTime.now().hour < 12
      ? 'Good Morning'
      : (DateTime.now().hour < 17 ? 'Good Afternoon' : 'Good Evening');
  String _getTodaysDate() => DateFormat('EEEE, d MMMM').format(DateTime.now());
  String _getMotivationalQuote() =>
      motivationalQuotes[DateTime.now().day % motivationalQuotes.length];

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

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        int crossAxisCount = isWide ? 4 : 2;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              children: [
                _buildWelcomeSection(textTheme, colorScheme),
                const SizedBox(height: 24),
                _buildAutoStepCounterCard(textTheme, colorScheme),
                const SizedBox(height: 24),
                _buildDailySummaryCard(textTheme, colorScheme),
                const SizedBox(height: 24),
                _buildQuickStartButtons(
                    context, textTheme, colorScheme, crossAxisCount),
                const SizedBox(height: 24),
                _buildWeeklyProgressCard(context, textTheme, colorScheme),
                const SizedBox(height: 24),
                _buildWaterIntakeCard(textTheme, colorScheme),
                const SizedBox(height: 24),
                _buildAchievementsCard(textTheme, colorScheme),
                const SizedBox(height: 24),
                const AdBanner(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${_getGreeting()}, $userName!',
            style:
                textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(_getTodaysDate(),
            style: textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12)),
          child: Text('"${_getMotivationalQuote()}"',
              style: textTheme.titleSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: colorScheme.primary.withOpacity(0.9)),
              textAlign: TextAlign.center),
        )
      ],
    );
  }

  Widget _buildAutoStepCounterCard(
      TextTheme textTheme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Auto Step Tracking',
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Icon(Icons.directions_walk, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'ON',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDailySummaryCard(TextTheme textTheme, ColorScheme colorScheme) {
    final double stepProgress = (_currentSteps / stepGoal).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 12.0,
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
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Countup(
                          begin: 0,
                          end: _currentSteps.toDouble(),
                          duration: const Duration(milliseconds: 1200),
                          separator: ',',
                          style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary)),
                      Text(' steps',
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.primary)),
                    ],
                  ),
                  Text('Goal: ${NumberFormat.decimalPattern().format(stepGoal)}',
                      style: textTheme.titleSmall
                          ?.copyWith(color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(textTheme, colorScheme, Icons.local_fire_department,
                    '${caloriesBurned.toStringAsFixed(0)} kcal', 'Calories'),
                _statItem(textTheme, colorScheme, Icons.route,
                    '${distanceCovered.toStringAsFixed(1)} km', 'Distance'),
                _statItem(textTheme, colorScheme, Icons.timer,
                    '$activeMinutes min', 'Active Time'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(TextTheme textTheme, ColorScheme colorScheme, IconData icon,
      String value, String label) {
    return Column(
      children: [
        Icon(icon, color: colorScheme.secondary, size: 24),
        const SizedBox(height: 8),
        Text(value,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildQuickStartButtons(BuildContext context, TextTheme textTheme,
      ColorScheme colorScheme, int crossAxisCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Start',
            style:
                textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3,
          children: [
            _quickStartWorkoutButton(
                context, Icons.directions_walk, 'Start Walk'),
            _quickStartWorkoutButton(
                context, Icons.directions_run, 'Start Run'),
            _quickStartWorkoutButton(
                context, Icons.directions_bike, 'Start Cycling'),
            _quickStartWorkoutButton(
                context, Icons.fitness_center, 'Custom Workout'),
          ],
        ),
      ],
    );
  }

  Widget _quickStartWorkoutButton(
      BuildContext context, IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () => context.go('/add'),
      icon: Icon(icon, size: 24),
      label: FittedBox(
          child: Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildWeeklyProgressCard(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Weekly Progress",
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: BarChart(
                _buildBarChartData(colorScheme),
                swapAnimationDuration: const Duration(milliseconds: 450),
                swapAnimationCurve: Curves.easeInOutSine,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/analytics'),
                child: const Text('View Detailed Stats →'),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartData _buildBarChartData(ColorScheme colorScheme) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: (weeklySteps.values.reduce((a, b) => a > b ? a : b) * 1.2)
          .toDouble(),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) =>
              BarTooltipItem((rod.toY - 1).toStringAsFixed(0),
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
              String text;
              switch (value.toInt()) {
                case 0:
                  text = 'M';
                  break;
                case 1:
                  text = 'T';
                  break;
                case 2:
                  text = 'W';
                  break;
                case 3:
                  text = 'T';
                  break;
                case 4:
                  text = 'F';
                  break;
                case 5:
                  text = 'S';
                  break;
                case 6:
                  text = 'S';
                  break;
                default:
                  text = '';
                  break;
              }
              return SideTitleWidget(
                  child: Text(text, style: style), axisSide: meta.axisSide);
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      barGroups: weeklySteps.entries
          .map((entry) => BarChartGroupData(x: entry.key, barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  color: entry.key == DateTime.now().weekday - 1
                      ? colorScheme.primary
                      : colorScheme.secondary,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                )
              ]))
          .toList(),
    );
  }

  Widget _buildWaterIntakeCard(TextTheme textTheme, ColorScheme colorScheme) {
    double waterProgress = (currentWater / waterGoal).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Water Intake',
                    style: textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text(
                    '${currentWater.toStringAsFixed(0)} / ${waterGoal.toStringAsFixed(0)} ml',
                    style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            LinearPercentIndicator(
              percent: waterProgress,
              lineHeight: 16.0,
              barRadius: const Radius.circular(8),
              progressColor: colorScheme.primary,
              backgroundColor: colorScheme.primary.withOpacity(0.2),
              animation: true,
              animationDuration: 1000,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: _addWater,
                    icon: const Icon(Icons.add),
                    label: const Text("Add 250ml")),
                TextButton(onPressed: _resetWater, child: const Text('Reset')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard(TextTheme textTheme, ColorScheme colorScheme) {
    bool goalAchieved = _currentSteps >= stepGoal;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _achievementItem(
                  textTheme,
                  colorScheme,
                  goalAchieved ? colorScheme.secondary : Colors.grey,
                  Icons.check_circle,
                  'Daily Goal',
                  goalAchieved ? 'Achieved!' : 'Keep Going'),
            ),
            Expanded(
              child: _achievementItem(
                  textTheme,
                  colorScheme,
                  colorScheme.secondary,
                  Icons.local_fire_department,
                  'Weekly Streak',
                  '$weeklyStreak Days'),
            ),
            Expanded(
              child: _achievementItem(
                  textTheme,
                  colorScheme,
                  Colors.grey,
                  Icons.star_border,
                  'New Badge',
                  'Coming Soon'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _achievementItem(TextTheme textTheme, ColorScheme colorScheme,
      Color iconColor, IconData icon, String label, String status) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 32),
        const SizedBox(height: 8),
        Text(label,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(status,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
      ],
    );
  }
}
