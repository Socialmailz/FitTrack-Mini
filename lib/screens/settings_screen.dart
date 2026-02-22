
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  UserSettings? _userSettings;

  @override
  void initState() {
    super.initState();
    _userSettings = Hive.box<UserSettings>(DatabaseService.userSettingsBoxName).get(0);
  }

  void _showWaterGoalDialog() {
    if (_userSettings == null) return;
    final TextEditingController controller = TextEditingController(text: _userSettings!.dailyWaterGoal.toString());
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
                  setState(() {
                    _userSettings!.dailyWaterGoal = newGoal;
                    _userSettings!.save();
                  });
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          ListTile(
            title: const Text('Daily Water Goal'),
            subtitle: Text('${_userSettings?.dailyWaterGoal ?? 2000} ml'),
            leading: const Icon(Icons.local_drink),
            onTap: _showWaterGoalDialog,
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
  }
}
