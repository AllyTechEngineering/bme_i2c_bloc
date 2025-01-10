import 'package:flutter/foundation.dart';

class HeaterPid {
  static const double kp = 2.0; // Proportional gain (best guess)
  static const double ki = 0.5; // Integral gain (best guess)
  static const double kd = 1.0; // Derivative gain (best guess)

  double _previousError = 0.0;
  double _integral = 0.0;

  double? _setpoint;
  double? _currentTemperature;
  DateTime? _previousTime;

  /// Method to update the setpoint and current temperature
  void updateValues({required double setpoint, required double currentTemperature}) {
    _setpoint = setpoint;
    _currentTemperature = currentTemperature;
    debugPrint('Updated values - Setpoint: $_setpoint, Current Temperature: $_currentTemperature');
    var temp = compute();
    debugPrint('Computed duty cycle: $temp');
  }

  /// Compute the duty cycle based on the current temperature and setpoint
  double compute() {
    if (_setpoint == null || _currentTemperature == null) {
      throw Exception('Setpoint and current temperature must be set before calling compute.');
    }

    // Calculate deltaTime
    DateTime now = DateTime.now();
    double deltaTime = _previousTime != null
        ? now.difference(_previousTime!).inMilliseconds / 1000.0
        : 1.0; // Default to 1 second for the first iteration
    _previousTime = now;

    debugPrint('DeltaTime: $deltaTime');

    // Calculate the error
    double error = _setpoint! - _currentTemperature!;
    debugPrint('Setpoint: $_setpoint, Current Temperature: $_currentTemperature');
    debugPrint('Error: $error');

    // Proportional term
    double proportional = kp * error;
    debugPrint('Proportional: $proportional');

    // Integral term
    _integral += error * deltaTime;
    double integral = ki * _integral;
    debugPrint('Integral: $integral');

    // Derivative term
    double derivative = kd * (error - _previousError) / deltaTime;
    debugPrint('Derivative: $derivative');

    // Update the previous error for the next iteration
    _previousError = error;

    // Calculate the output (duty cycle)
    double output = proportional + integral + derivative;
    debugPrint('Raw Output: $output');

    // Clamp the output to 0-100
    output = output.clamp(0.0, 100.0);
    debugPrint('Clamped Output (Duty Cycle): $output');

    return output;
  }
}
