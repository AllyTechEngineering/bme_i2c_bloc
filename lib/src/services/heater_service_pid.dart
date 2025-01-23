import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HeaterServicePid {
  static const double kp = 2.0; // Proportional gain (best guess)
  static const double ki = 0.1; // Integral gain (best guess)
  static const double kd = 0.5; // Derivative gain (best guess)

  double _previousError = 0.0;
  double _integral = 0.0;

  static double? _setpoint = 0.0;
  static double? _currentTemperature;
  DateTime? _previousTime;

  static PWM pwm = PWM(0, 0);

  int setPwmPeriod = 10000000; //10000000ns = 100Hz freq, 1000000ns = 1000 Hz

  void initializeHeaterService() {
    try {
      // debugPrint('First try catch, pwm = PWM(0, 0);');
      // pwm = PWM(0, 0);
      // pwm.setPolarity(Polarity.pwmPolarityInversed);
      debugPrint('HeaterServicePid PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('pwm = PWM(0, 0); Error: $e');
    }
    try {
      // debugPrint('Second try catch, pwm.setPeriodNs(10000000);');
      pwm.setPeriodNs(10000000);
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('pwm.setPeriodNs(10000000) Error: $e');
    }
    try {
      // debugPrint('Third try catch, pwm.setDutyCycleNs(5000000);');
      pwm.setDutyCycleNs(0);
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('pwm.setDutyCycleNs(5000000) Error: $e');
    }
    try {
      // debugPrint('Fourth try catch, pwm.enable();');
      pwm.enable();
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('pwm.enable() Error: $e');
    }
    try {
      // debugPrint('Fifth try catch, Polarity.pwmPolarityNormal');
      pwm.setPolarity(Polarity.pwmPolarityNormal);
      // debugPrint('Temperture PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('Polarity.pwmPolarityNormal Error: $e');
    }
  }

  void disableHeaterPwmPid() {
    pwm.disable();
    debugPrint('HeaterServicePid PWM Infor: ${pwm.getPWMinfo()}');
  }
  void enableHeaterPwmPid() {
    pwm.enable();
    debugPrint('HeaterServicePid PWM Infor: ${pwm.getPWMinfo()}');
  }

  void disposeHeaterPwmPid() {
    debugPrint('In HeaterServicePid disposeHeaterPwmPid method');
    pwm.dispose();
  }

  void updatePwmDutyCycle() {
    pwm.setDutyCycleNs(computePidDutyCycle().toInt());
    // debugPrint('In updatePwmDutyCycle PWM Infor: ${pwm.getPWMinfo()}');
  }

  void updateSetpoint(double setpoint) {
    _setpoint = setpoint;
    // debugPrint(
    //     'in HeaterService class: Heater setpoint updated to: $_setpoint');
  }

  void updateTemperature({required double currentTemperature}) {
    _currentTemperature = currentTemperature;
    updatePwmDutyCycle();
    // debugPrint(
    //     'in HeaterService class: Current temperature updated to: $_currentTemperature');
  }

  double computePidDutyCycle() {
    // debugPrint(
    //     'In computePidDutyCycle and the setpoint is: $_setpoint, and the current temperature is: $_currentTemperature');
    if (_setpoint == null || _currentTemperature == null) {
      throw Exception(
          'Setpoint and current temperature must be set before calling computePidDutyCycle.');
    }

    // Calculate deltaTime
    DateTime now = DateTime.now();
    double deltaTime = _previousTime != null
        ? now.difference(_previousTime!).inMilliseconds / 500.0
        : 1.0; // Default to 1 second for the first iteration
    _previousTime = now;

    // debugPrint('DeltaTime: $deltaTime');

    // Calculate the error
    double error = _setpoint! - _currentTemperature!;
    // debugPrint(
    //     'Setpoint: $_setpoint, Current Temperature: $_currentTemperature');
    // debugPrint('Error: $error');

    // Proportional term
    double proportional = kp * error;
    // debugPrint('Proportional: $proportional');

    // Integral term with clamping for windup prevention
    _integral += error * deltaTime;
    const double maxIntegral = 100.0 / ki; // Adjust as necessary
    const double minIntegral = -1.0;
    _integral = _integral.clamp(minIntegral, maxIntegral);
    double integral = ki * _integral;

    // Derivative term
    double derivative = kd * (error - _previousError) / deltaTime;
    // debugPrint('Derivative: $derivative');

    // Update the previous error for the next iteration
    _previousError = error;

    // Calculate the dutyCycleComputed (duty cycle)
    double dutyCycleComputed = proportional + integral + derivative;
    // debugPrint('Temperature Propotional: $proportional');
    // debugPrint('Temperature Integral: $integral');
    // debugPrint('Temperature Derivative: $derivative');
    // debugPrint('Raw Temperature Dutycycle: $dutyCycleComputed');

    // Clamp the dutyCycleComputed to 0-100
    dutyCycleComputed = dutyCycleComputed.clamp(0.0, 100.0);
    dutyCycleComputed = dutyCycleComputed * 100000;
    // debugPrint('Clamped Temperature Dutycycle (0-100): $dutyCycleComputed');

    return dutyCycleComputed;
  }
}
