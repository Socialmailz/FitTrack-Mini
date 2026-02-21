
import 'package:flutter/material.dart';

class WaterCard extends StatelessWidget {
  final int waterIntake;
  final VoidCallback onAddWater;
  final VoidCallback onResetWater;

  const WaterCard({
    super.key,
    required this.waterIntake,
    required this.onAddWater,
    required this.onResetWater,
  });

  @override
  Widget build(BuildContext context) {
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
            Text('$waterIntake ml', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onAddWater, child: const Text('Add 250ml')),
          ],
        ),
      ),
    );
  }
}
