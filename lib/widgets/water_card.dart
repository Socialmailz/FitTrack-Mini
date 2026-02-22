
import 'package:flutter/material.dart';

class WaterCard extends StatelessWidget {
  final int waterIntake;
  final int waterGoal;
  final VoidCallback onAddWater;
  final VoidCallback onResetWater;

  const WaterCard({
    super.key,
    required this.waterIntake,
    required this.waterGoal,
    required this.onAddWater,
    required this.onResetWater,
  });

  @override
  Widget build(BuildContext context) {
    double progress = waterIntake / waterGoal;
    if (progress > 1.0) progress = 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Water Intake', style: Theme.of(context).textTheme.titleLarge),
                IconButton(onPressed: onResetWater, icon: const Icon(Icons.refresh)),
              ],
            ),
            const SizedBox(height: 16),
            Text('$waterIntake / $waterGoal ml', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onAddWater, child: const Text('Add 250ml')),
          ],
        ),
      ),
    );
  }
}
