
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/models/user_settings.dart';
import 'package:myapp/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  // A method to show the dialog for updating the water goal.
  void _showWaterGoalDialog(BuildContext context, UserSettings userSettings) {
    final TextEditingController controller = TextEditingController(text: userSettings.dailyWaterGoal.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Daily Water Goal'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Water goal (ml)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newGoal = int.tryParse(controller.text);
                if (newGoal != null && newGoal > 0) {
                  // Update the settings and save it. The ValueListenableBuilder will automatically rebuild the UI.
                  userSettings.dailyWaterGoal = newGoal;
                  userSettings.save();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use a ValueListenableBuilder to listen to the UserSettings box.
    // This is the most robust way to handle UI updates from Hive.
    return ValueListenableBuilder<Box<UserSettings>>(
      valueListenable: DatabaseService.getUserSettingsBox().listenable(keys: [DatabaseService.userSettingsKey]),
      builder: (context, box, _) {
        // Get the single UserSettings object. Thanks to our fix in DatabaseService, this will never be null.
        final userSettings = box.get(DatabaseService.userSettingsKey)!;
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: [
              ListTile(
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: userSettings.isDarkMode,
                  onChanged: (value) {
                    // Update the setting and save it. This will trigger the listeners.
                    userSettings.isDarkMode = value;
                    userSettings.save();
                    // Also update the theme provider.
                    themeProvider.setTheme(value ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ),
              ListTile(
                title: const Text('Daily Water Goal'),
                subtitle: Text('${userSettings.dailyWaterGoal} ml'),
                leading: const Icon(Icons.local_drink),
                onTap: () => _showWaterGoalDialog(context, userSettings),
              ),
              ListTile(
                title: const Text('About'),
                leading: const Icon(Icons.info_outline),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'FitTrack', 
                    applicationVersion: '1.0.0',
                    children: [
                      const Text('FitTrack is a simple app to track your fitness goals.'),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
