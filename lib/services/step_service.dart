
import 'package:pedometer/pedometer.dart';

class StepService {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  void init() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _stepCountStream = Pedometer.stepCountStream;
  }

  Stream<StepCount> get stepCountStream => _stepCountStream;
  Stream<PedestrianStatus> get pedestrianStatusStream => _pedestrianStatusStream;
}
