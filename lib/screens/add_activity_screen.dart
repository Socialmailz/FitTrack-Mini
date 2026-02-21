
import 'package:flutter/material.dart';
import 'package:myapp/data/activity_data.dart';
import 'package:myapp/models/activity.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _activityType;
  int? _duration;
  double? _distance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _activityType,
                hint: const Text('Activity Type'),
                onChanged: (String? newValue) {
                  setState(() {
                    _activityType = newValue;
                  });
                },
                items: <String>['Running', 'Walking', 'Cycling', 'Swimming']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
                  }
                  return null;
                },
                onSaved: (value) {
                  _duration = int.tryParse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Distance (km)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a distance';
                  }
                  return null;
                },
                onSaved: (value) {
                  _distance = double.tryParse(value!);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newActivity = Activity(
                      type: _activityType!,
                      duration: _duration!,
                      distance: _distance!,
                      date: DateTime.now(),
                    );
                    ActivityData.addActivity(newActivity);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
