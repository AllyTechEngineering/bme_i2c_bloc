import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HeaterPwmService {
  PWM pwm = PWM(0, 0);
  int setPwmPeriod = 10000000;
  int setPwmDutyCycle = 8000000;

  void updateTemperature(String temperatureString) {
    debugPrint(' in heater_pwm_service Temperature string: $temperatureString');
    // try {
    //   int temperature = int.parse(temperatureString);
    //   debugPrint('Temperature: $temperature');
    //   // Use the temperature value to control the PWM signal
    // } catch (e) {
    //   debugPrint('Error: $e');
    // }
  }


  void setPwm(setPwmPeriod, setPwmDutyCycle) {
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
