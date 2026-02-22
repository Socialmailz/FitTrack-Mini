
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/activity.dart';
import 'package:myapp/services/database_service.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _activityType;
  int? _duration;
  int? _calories;
  double? _distance;
  DateTime _dateTime = DateTime.now();

  final List<String> _activityTypes = ['Walking', 'Running', 'Cycling', 'Swimming', 'Workout'];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_dateTime));
    if (picked != null) {
      setState(() {
        _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, picked.hour, picked.minute);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _dateTime, firstDate: DateTime(2000), lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _dateTime = DateTime(picked.year, picked.month, picked.day, _dateTime.hour, _dateTime.minute);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_calories == null && _duration != null) {
        _calories = _estimateCalories(_activityType!, _duration!, _distance);
      }

      final newActivity = Activity(
        type: _activityType!,
        duration: _duration ?? 0,
        calories: _calories ?? 0,
        distance: _distance ?? 0,
        timestamp: _dateTime,
      );
      
      Hive.box<Activity>(DatabaseService.activitiesBoxName).add(newActivity);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity added successfully!')),
      );
      context.pop();
    }
  }

  int _estimateCalories(String activityType, int duration, double? distance) {
    switch (activityType) {
      case 'Running':
        return (distance != null) ? (distance * duration * 0.1).toInt() : duration * 10;
      case 'Cycling':
        return (distance != null) ? (distance * duration * 0.05).toInt() : duration * 8;
      case 'Swimming':
        return duration * 12;
      case 'Workout':
        return duration * 5;
      case 'Walking':
       return (distance != null) ? (distance * duration * 0.08).toInt() : duration * 4;
      default:
        return duration * 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log New Activity'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Activity Type'),
                        initialValue: _activityType,
                        items: _activityTypes.map((String type) {
                          return DropdownMenuItem<String>(value: type, child: Text(type));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _activityType = newValue;
                          });
                        },
                        validator: (value) => value == null ? 'Please select an activity type' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _duration = int.tryParse(value ?? ''),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a duration';
                          }
                          return null;
                        },
                      ),
                      if (_activityType == 'Running' || _activityType == 'Walking' || _activityType == 'Cycling')
                        const SizedBox(height: 20),
                      if (_activityType == 'Running' || _activityType == 'Walking' || _activityType == 'Cycling')
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Distance (km)'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _distance = double.tryParse(value ?? ''),
                        ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Calories Burned (optional)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _calories = int.tryParse(value ?? ''),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'Date'),
                                child: Text(DateFormat.yMMMd().format(_dateTime)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectTime(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'Time'),
                                child: Text(DateFormat.jm().format(_dateTime)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Add Activity'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
