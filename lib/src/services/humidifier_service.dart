import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HumidifierService {

  static double? _setpointHumidity = 0.0;
  static double? _currentHumidity;

  // ignore: prefer_typing_uninitialized_variables
  var pwm = PWM(0, 1);

  int setPwmPeriod = 10000000; //10000000ns = 100Hz freq, 1000000ns = 1000 Hz

  void initializeHumidifierService() {
    try {
      // debugPrint('Humidity First try catch, pwm = PWM(0, 0);');
      pwm = PWM(0, 1);
      // pwm.setPolarity(Polarity.pwmPolarityInversed);
      // debugPrint('Humidity PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      pwm.disable();
      pwm.dispose();
      // debugPrint('Humidity pwm = PWM(0, 0); Error: $e');
    }
    try {
      debugPrint('Humidity Second try catch, pwm.setPeriodNs(10000000);');
      pwm.setPeriodNs(10000000);
      // debugPrint('Humidity PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      pwm.disable();
      pwm.dispose();
      // debugPrint('Humidity pwm.setPeriodNs(10000000) Error: $e');
    }
    try {
      // debugPrint('Humidity Third try catch, pwm.setDutyCycleNs(5000000);');
      pwm.setDutyCycleNs(0);
      // debugPrint('Humidity PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      pwm.disable();
      pwm.dispose();
      // debugPrint('Humidity pwm.setDutyCycleNs(5000000) Error: $e');
    }
    try {
      // debugPrint('Humidity Fourth try catch, pwm.enable();');
      pwm.enable();
      // debugPrint('Humidity PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      pwm.disable();
      pwm.dispose();
      // debugPrint('Humidity pwm.enable() Error: $e');
    }
    try {
      debugPrint('Fifth try catch, Polarity.pwmPolarityNormal');
      pwm.setPolarity(Polarity.pwmPolarityNormal);
      debugPrint('Humidifier PWM Infor: ${pwm.getPWMinfo()}');
    } catch (e) {
      pwm.disable();
      pwm.dispose();
      debugPrint('Polarity.pwmPolarityNormal Error: $e');
    }
  }

  void disablePwm() {
    pwm.disable();
  }

  void disposePwm() {
    pwm.dispose();
  }


  void updateSetpoint(double setpoint) {
    _setpointHumidity = setpoint;
    // debugPrint(
    //     'in HumidifierService class: Heater setpoint updated to: $_setpointHumidity');
  }

  void updateHumidity({required double currentHumidity}) {
    _currentHumidity = currentHumidity;
    // debugPrint(
    //     'in HumidifierService class: Current humidity updated to: $_currentHumidity ');
  }
}
