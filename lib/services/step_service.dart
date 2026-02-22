
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:myapp/models/daily_steps.dart';
import 'package:pedometer/pedometer.dart';
import 'package:intl/intl.dart';

part 'step_service.g.dart';

@HiveType(typeId: 4)
class DailyStepsAdapter extends TypeAdapter<DailySteps> {
  @override
  final int typeId = 4;

  @override
  DailySteps read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySteps(
      date: fields[0] as DateTime,
      steps: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailySteps obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.steps);
  }
}

class StepService {
  late Stream<StepCount> _stepCountStream;
  late Box<DailySteps> _stepsBox;
  final double _strideLengthInMeters = 0.762;

  Future<void> init() async {
    _stepsBox = await Hive.openBox<DailySteps>('daily_steps');
    _initPedometer();
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
  }

  void _onStepCount(StepCount event) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DailySteps? dailySteps = _stepsBox.get(today);

    if (dailySteps == null) {
      dailySteps = DailySteps(date: DateTime.now(), steps: event.steps);
    } else {
      dailySteps.steps = event.steps;
    }
    _stepsBox.put(today, dailySteps);
  }

  void _onStepCountError(error) {
    print('Pedometer Error: $error');
  }

  int getStepsForDay(DateTime date) {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final dailySteps = _stepsBox.get(dateString);
    return dailySteps?.steps ?? 0;
  }

  double getDistanceForDay(DateTime date) {
    final steps = getStepsForDay(date);
    return (steps * _strideLengthInMeters) / 1000; // Return distance in kilometers
  }

  Stream<int> get stepCountStream {
    return _stepCountStream.map((event) => event.steps);
  }

  Stream<double> get distanceStream {
    return stepCountStream.map((steps) => (steps * _strideLengthInMeters) / 1000);
  }
}
