import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HeaterService {
  final double hysteresis = 0.5;
  bool _heaterState = false;
  static double? _setpointTemperature = 0.0;
  static double? _currentTemperature;

  // ignore: prefer_typing_uninitialized_variables
  var pwm = PWM(0, 0);

  int setPwmPeriod = 10000000; //10000000ns = 100Hz freq, 1000000ns = 1000 Hz

  void initializeHeaterService() {
    try {
      // debugPrint('First try catch, pwm = PWM(0, 0);');
      pwm = PWM(0, 0);
      // pwm.setPolarity(Polarity.pwmPolarityInversed);
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      pwm.disable();
      pwm.dispose();
      // debugPrint('pwm = PWM(0, 0); Error: $e');
    }
    try {
      // debugPrint('Second try catch, pwm.setPeriodNs(10000000);');
      pwm.setPeriodNs(10000000);
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      pwm.disable();
      pwm.dispose();
      // debugPrint('pwm.setPeriodNs(10000000) Error: $e');
    }
    try {
      // debugPrint('Third try catch, pwm.setDutyCycleNs(5000000);');
      pwm.setDutyCycleNs(0);
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      pwm.disable();
      pwm.dispose();
      // debugPrint('pwm.setDutyCycleNs(5000000) Error: $e');
    }
    try {
      // debugPrint('Fourth try catch, pwm.enable();');
      pwm.enable();
      // debugPrint('PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      pwm.disable();
      pwm.dispose();
      // debugPrint('pwm.enable() Error: $e');
    }
    try {
      // debugPrint('Fifth try catch, Polarity.pwmPolarityNormal');
      pwm.setPolarity(Polarity.pwmPolarityNormal);
      // debugPrint('Temperture PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      pwm.disable();
      pwm.dispose();
      // debugPrint('Polarity.pwmPolarityNormal Error: $e');
    }
  }

  void disablePwm() {
    pwm.disable();
  }

  void disposePwm() {
    pwm.dispose();
  }

  void updateSetpoint(double setpoint) {
    _setpointTemperature = setpoint;
    debugPrint(
        'in HeaterService class: Heater setpoint updated to: $_setpointTemperature');
  }

  void updateTemperature({required double currentTemperature}) {
    _currentTemperature = currentTemperature;
    debugPrint(
        'in HeaterService class: Current temperature updated to: $_currentTemperature');
    updateHeaterState();
  }

  // Method to update the heater state
  void updateHeaterState() {
    if (_currentTemperature! < _setpointTemperature! - hysteresis) {
      _heaterState = true;
      debugPrint('Heater is ON: $_heaterState');
      debugPrint('Current Temperature: $_currentTemperature');
      debugPrint('Setpoint Temperature: $_setpointTemperature');
    } else if (_currentTemperature! > _setpointTemperature! + hysteresis) {
      _heaterState = false;
      debugPrint('Heater is OFF: $_heaterState');
      debugPrint('Current Temperature: $_currentTemperature');
      debugPrint('Setpoint Temperature: $_setpointTemperature');
    }
  }
}
