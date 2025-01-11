import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HeaterService {
  static const double kp = 2.0; // Proportional gain (best guess)
  static const double ki = 0.0; // Integral gain (best guess)
  static const double kd = 1.0; // Derivative gain (best guess)

  double _previousError = 0.0;
  double _integral = 0.0;

  static double? _setpoint = 0.0;
  static double? _currentTemperature;
  DateTime? _previousTime;

  // ignore: prefer_typing_uninitialized_variables
  var pwm;

  int setPwmPeriod = 10000000; //10000000ns = 100Hz freq, 1000000ns = 1000 Hz

  void initializeHeaterService() {
    try {
      // debugPrint('First try catch, pwm = PWM(0, 0);');
      pwm = PWM(0, 0);
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      disablePwm();
      disposePwm();
      debugPrint('pwm = PWM(0, 0); Error: $e');
    }
    try {
      // debugPrint('Second try catch, pwm.setPeriodNs(10000000);');
      pwm.setPeriodNs(10000000);
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      disablePwm();
      disposePwm();
      debugPrint('pwm.setPeriodNs(10000000) Error: $e');
    }
    try {
      // debugPrint('Third try catch, pwm.setDutyCycleNs(5000000);');
      pwm.setDutyCycleNs(0);
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      disablePwm();
      disposePwm();
      debugPrint('pwm.setDutyCycleNs(5000000) Error: $e');
    }
        try {
      // debugPrint('Fourth try catch, pwm.enable();');
      pwm.enable();
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      disablePwm();
      disposePwm();
      debugPrint('pwm.enable() Error: $e');
    }
  }

  void disablePwm() {
    pwm.disable();
  }

  void disposePwm() {
    pwm.dispose();
  }
  void updateSetpoint(double setpoint) {
    _setpoint = setpoint;
    debugPrint('in HeaterService class: Heater setpoint updated to: $_setpoint');
  }


  void updateTemperature(
      { required double currentTemperature}) {
    _currentTemperature = currentTemperature;

    var temp = heaterServiceComputeDutyCycle();
    debugPrint('heaterServiceComputeDutyCycled duty cycle: $temp');
  }

  /// heaterServiceComputeDutyCycle the duty cycle based on the current temperature and setpoint
  double heaterServiceComputeDutyCycle() {
    debugPrint('In heaterServiceComputeDutyCycle and the setpoint is: $_setpoint, and the current temperature is: $_currentTemperature');
    if (_setpoint == null || _currentTemperature == null) {
      throw Exception(
          'Setpoint and current temperature must be set before calling heaterServiceComputeDutyCycle.');
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
    debugPrint(
        'Setpoint: $_setpoint, Current Temperature: $_currentTemperature');
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

    // Calculate the dutyCycleComputed (duty cycle)
    double dutyCycleComputed = proportional + integral + derivative;
    debugPrint('Raw Dutycycle: $dutyCycleComputed');

    // Clamp the dutyCycleComputed to 0-100
    dutyCycleComputed = dutyCycleComputed.clamp(0.0, 100.0);
    debugPrint('Clamped Dutycycle (0-100): $dutyCycleComputed');

    return dutyCycleComputed;
  }
}
