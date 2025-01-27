import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HumidifierServicePid {
  static const double kp = 2.0; // Proportional gain (best guess)
  static const double ki = 0.1; // Integral gain (best guess)
  static const double kd = 0.5; // Derivative gain (best guess)

  double _previousError = 0.0;
  double _integral = 0.0;

  static double? _setpointHumidity = 0.0;
  static double? _currentHumidity;
  DateTime? _previousTime;

  static PWM pwm = PWM(0, 1);

  int setPwmPeriod = 10000000; //10000000ns = 100Hz freq, 1000000ns = 1000 Hz

  void initializeHumidifierService() {
    try {
      // debugPrint('Humidity First try catch, pwm = PWM(0, 0);');
      pwm = PWM(0, 1);
      // pwm.setPolarity(Polarity.pwmPolarityInversed);
      // debugPrint('HumidifierService Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('Humidity pwm = PWM(0, 0); Error: $e');
    }
    try {
      // debugPrint('Humidity Second try catch, pwm.setPeriodNs(10000000);');
      pwm.setPeriodNs(10000000);
      // debugPrint('Humidity PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('Humidity pwm.setPeriodNs(10000000) Error: $e');
    }
    try {
      // debugPrint('Humidity Third try catch, pwm.setDutyCycleNs(5000000);');
      pwm.setDutyCycleNs(0);
      // debugPrint('Humidity PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('Humidity pwm.setDutyCycleNs(5000000) Error: $e');
    }
    try {
      // debugPrint('Humidity Fourth try catch, pwm.enable();');
      pwm.enable();
      // debugPrint('Humidity PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('Humidity pwm.enable() Error: $e');
    }
    try {
      // debugPrint('Fifth try catch, Polarity.pwmPolarityNormal');
      pwm.setPolarity(Polarity.pwmPolarityNormal);
      // debugPrint('Humidifier PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('Polarity.pwmPolarityNormal Error: $e');
    }
  }

  void disableHumidifierPwmPid() {
    pwm.disable();
    // debugPrint('HumidifierService Infor: ${pwm.getPWMinfo()}');
  }
  void enableHumidifierPwmPid() {
    pwm.enable();
    // debugPrint('HumidifierService Infor: ${pwm.getPWMinfo()}');
  }

  void disposeHumidifierPwmPid() {
    // debugPrint('In Humidity disposeHumidifierPwm() method');
    pwm.dispose();
  }

  void updatePwmDutyCycle() {
    pwm.setDutyCycleNs(computePidDutyCycle().toInt());
    // debugPrint('In Humidity updatePwmDutyCycle PWM Infor: ${pwm.getDutyCycleNs()}');
  }

  void updateSetpoint(double setpoint) {
    _setpointHumidity = setpoint;
    // debugPrint(
    //     'in HumidifierService class: Heater setpoint updated to: $_setpointHumidity');
  }

  void updateHumidity({required double currentHumidity}) {
    _currentHumidity = currentHumidity;
    updatePwmDutyCycle();
    // debugPrint(
    //     'in HumidifierService class: Current humidity updated to: $_currentHumidity ');
  }

  double computePidDutyCycle() {
    // debugPrint(
    //     'In Humidity computePidDutyCycle and the setpointHumidity is: $_setpointHumidity, and the current humidity is: $_currentHumidity ');
    if (_setpointHumidity == null || _currentHumidity == null) {
      throw Exception(
          'setpointHumidity and current humidity must be set before calling computePidDutyCycle.');
    }

    // Calculate deltaTime
    DateTime now = DateTime.now();
    double deltaTime = _previousTime != null
        ? now.difference(_previousTime!).inMilliseconds / 500.0
        : 1.0; // Default to 1 second for the first iteration
    _previousTime = now;

    // debugPrint('Humidity DeltaTime: $deltaTime');

    // Calculate the error
    double error = _setpointHumidity! - _currentHumidity!;
    // debugPrint(
    //     'setpointHumidity: $_setpointHumidity, Current Humidity: $_currentHumidity ');
    // debugPrint('Humidity Error: $error');

    // Proportional term
    double proportional = kp * error;
    // debugPrint('Humidity Proportional: $proportional');

    // Integral term
    // _integral += error * deltaTime;
    // double integral = ki * _integral;

    // Integral term with clamping for windup prevention
    _integral += error * deltaTime;
    const double maxIntegral = 100.0 / ki; // Adjust as necessary
    const double minIntegral = -1.0;
    _integral = _integral.clamp(minIntegral, maxIntegral);
    double integral = ki * _integral;
    // debugPrint('Humidity Integral: $integral');

    // Derivative term
    double derivative = kd * (error - _previousError) / deltaTime;
    // debugPrint('Humidity Derivative: $derivative');

    // Update the previous error for the next iteration
    _previousError = error;

    // Calculate the humidityDutycycleComputed (duty cycle)
    double humidityDutycycleComputed = proportional + integral + derivative;
    // debugPrint('Humidifier Propotional: $proportional');
    // debugPrint('Humidifier Integral: $integral');
    // debugPrint('Humidifier Derivative: $derivative');
    // debugPrint('Raw Humidity Dutycycle: $humidityDutycycleComputed');

    // Clamp the humidityDutycycleComputed to 0-100
    humidityDutycycleComputed = humidityDutycycleComputed.clamp(0.0, 100.0);
    humidityDutycycleComputed = humidityDutycycleComputed * 100000;
    // debugPrint(
    //     'Humidity Clamped Dutycycle (0-100): $humidityDutycycleComputed');

    return humidityDutycycleComputed;
  }
}
