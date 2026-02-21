
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  // Mock User Data
  String _name = "Alex Doe";
  String _email = "alex.doe@example.com";
  String _goal = "Lose 10 pounds";
  bool _notificationsEnabled = true;

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you would typically save the data to a backend or local storage
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  _buildProfileHeader(textTheme),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              initialValue: _name,
                              decoration: const InputDecoration(labelText: 'Full Name'),
                              onSaved: (value) => _name = value!,
                              validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: _email,
                              decoration: const InputDecoration(labelText: 'Email Address'),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) => _email = value!,
                              validator: (value) => !value!.contains('@') ? 'Please enter a valid email' : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: _goal,
                              decoration: const InputDecoration(labelText: 'Fitness Goal'),
                              onSaved: (value) => _goal = value!,
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: _saveProfile,
                              child: const Text('Save Changes'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsSection(textTheme),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(TextTheme textTheme) {
    return Column(
      children: [
        GestureDetector(
          onTap: _getImage,
          child: CircleAvatar(
            radius: 60,
            backgroundImage: _image != null ? FileImage(_image!) : null,
            child: _image == null
                ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        Text(_name, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(_email, style: textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildSettingsSection(TextTheme textTheme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Account Settings', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              secondary: const Icon(Icons.notifications_active_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.security_outlined),
              title: const Text('Privacy & Security'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () {},
            ),
             ListTile(
              leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
              title: Text('Logout', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
    );
  }
}
