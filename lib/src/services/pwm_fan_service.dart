import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class PwmFanService {
  static PWM pwm =
      PWM(0, 0); // PWM(0, 0) is the default PWM chip and channel GPIO 18
  static bool systemOnOffState = true;
  int setPwmPeriod = 10000000; //10000000ns = 100Hz freq, 1000000ns = 1000 Hz

  void initializePwmFanService() {
    try {
      // pwm = PWM(0, 1);
      debugPrint('Initial PwmFan Info: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('Initial PwmFan Error: $e');
    }
    try {
      pwm.setPeriodNs(10000000);
      debugPrint('PwmFan period Info: ${pwm.getPeriodNs()}');
    } catch (e) {
      debugPrint('PwmFan period Error: $e');
    }
    try {
      pwm.setDutyCycleNs(0);
      debugPrint('PwmFan Dutycycle Info: ${pwm.getDutyCycleNs()}');
    } catch (e) {
      debugPrint('PwmFan Dutycycle Error: $e');
    }
    try {
      pwm.enable();
      debugPrint('PwmFan Enable Info: ${pwm.getEnabled()}');
    } catch (e) {
      debugPrint('PwmFan Enable Error: $e');
    }
    try {
      pwm.setPolarity(Polarity.pwmPolarityNormal);
      debugPrint('PwmFan Polarity Info: ${pwm.getPolarity()}');
      debugPrint('Final PwmFan Info: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('PwmFan Polarity Error: $e');
    }
  }

  void updatePwmDutyCycle(int updateDutyCycle) {
    debugPrint(
        'In PwmFan updatePwmDutyCycle systemOnOffSate: $systemOnOffState');
    if (systemOnOffState) {
      pwm.setDutyCycleNs(updateDutyCycle * 100000);
      debugPrint(
          'In PwmFan updatePwmDutyCycle DutyCycleNs= ${pwm.getDutyCycleNs()}');
      debugPrint('In PwmFan updatePwmDutyCycle PWM Info: ${pwm.getPWMinfo()}');
    }
  }

  void pwmFanSystemOnOff() {
    systemOnOffState = !systemOnOffState;
    debugPrint('In PwmFanService systemOnOffState: $systemOnOffState');
    if (!systemOnOffState) {
      pwm.disable();
      debugPrint('In PwmFanService enable: ${pwm.getEnabled()}');
    }
    if (systemOnOffState) {
      pwm.enable();
      debugPrint('In PwmFanService enable: ${pwm.getEnabled()}');
    }
  }
} // End of class PwmFanService
