import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HeaterPwmService {
  PWM pwm = PWM(0, 0);
  // 1000000 ns = 1 ms = 1000 Hz
  int setPwmPeriod = 10000000; //100 Hz frequency
  double setTemperature = 0.0;
  


  void updateTemperature(double temperatureHeaterPwm) {
    setTemperature = 50.0;
    debugPrint(
        ' in heater_pwm_service Temperature string: ${temperatureHeaterPwm.toStringAsFixed(2)}');
        
  }

  void setPwm(int setPwmDutyCycle) {
    try {
      pwm.setPeriodNs(setPwmPeriod);
      pwm.setDutyCycleNs(setPwmDutyCycle);
      pwm.enable();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void disablePwm() {
    pwm.disable();
  }

  void pwmDispose() {
    pwm.dispose();
  }
}
