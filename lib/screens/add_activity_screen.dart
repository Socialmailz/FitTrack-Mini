
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/activity_data.dart';
import 'package:myapp/models/activity.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _activityType;
  double? _distance;
  Duration? _duration;
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
      final newActivity = Activity(
        type: _activityType!,
        distance: _distance ?? 0.0,
        duration: _duration ?? Duration.zero,
        timestamp: _dateTime,
      );
      ActivityData.addActivity(newActivity);
      Navigator.of(context).pop();
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log New Activity'),
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
                      value: _activityType,
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
                      decoration: const InputDecoration(labelText: 'Distance (km)', suffixText: 'km'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onSaved: (value) => _distance = double.tryParse(value!),
                    ),
                    const SizedBox(height: 20),
                     TextFormField(
                      decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _duration = Duration(minutes: int.tryParse(value!) ?? 0),
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
