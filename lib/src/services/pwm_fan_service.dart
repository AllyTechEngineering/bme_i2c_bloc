import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class PwmFanService {
  static PWM pwm0 = PWM(2, 0);
  static PWM pwm1 = PWM(2, 1);
  static PWM pwm2 = PWM(2, 2);
  static PWM pwm3 = PWM(2, 3);

  static bool systemOnOffState = true;
  int setPwmPeriod = 10000000; //10000000ns = 100Hz freq, 1000000ns = 1000 Hz

  void initializePwmFanService() {
    try {
      // pwm = PWM(0, 1);
      debugPrint('Initial PwmFan Info: ${pwm0.getPWMinfo()}');
    } catch (e) {
      debugPrint('Initial PwmFan Error: $e');
    }
    try {
      pwm0.setPeriodNs(10000000);
      pwm1.setPeriodNs(10000000);
      pwm2.setPeriodNs(10000000);
      pwm3.setPeriodNs(10000000);
      debugPrint('PwmFan period Info: ${pwm0.getPeriodNs()}');
    } catch (e) {
      debugPrint('PwmFan period Error: $e');
    }
    try {
      pwm0.setDutyCycleNs(0);
      pwm1.setDutyCycleNs(0);
      pwm2.setDutyCycleNs(0);
      pwm3.setDutyCycleNs(0);
      debugPrint('PwmFan Dutycycle Info: ${pwm0.getDutyCycleNs()}');
    } catch (e) {
      debugPrint('PwmFan Dutycycle Error: $e');
    }
    try {
      pwm0.enable();
      pwm1.enable();
      pwm2.enable();
      pwm3.enable();
      debugPrint('PwmFan Enable Info: ${pwm0.getEnabled()}');
    } catch (e) {
      debugPrint('PwmFan Enable Error: $e');
    }
    try {
      pwm0.setPolarity(Polarity.pwmPolarityNormal);
      pwm1.setPolarity(Polarity.pwmPolarityNormal);
      pwm2.setPolarity(Polarity.pwmPolarityNormal);
      pwm3.setPolarity(Polarity.pwmPolarityNormal);
      // debugPrint('PwmFan Polarity Info: ${pwm.getPolarity()}');
      // debugPrint('Final PwmFan Info: ${pwm.getPWMinfo()}');
    } catch (e) {
      debugPrint('PwmFan Polarity Error: $e');
    }
  }

  void updatePwmDutyCycle(int updateDutyCycle) {
    // debugPrint(
    //     'In PwmFan updatePwmDutyCycle systemOnOffSate: $systemOnOffState');
    if (systemOnOffState) {
      pwm0.setDutyCycleNs(updateDutyCycle * 100000);
      pwm1.setDutyCycleNs(updateDutyCycle * 100000);
      pwm2.setDutyCycleNs(updateDutyCycle * 100000);
      pwm3.setDutyCycleNs(updateDutyCycle * 100000);
      debugPrint(
          'In PwmFan updatePwmDutyCycle DutyCycleNs= ${pwm0.getDutyCycleNs()}');
      debugPrint('In PwmFan updatePwmDutyCycle PWM Info: ${pwm0.getPWMinfo()}');
    }
  }

  void pwmFanSystemOnOff() {
    systemOnOffState = !systemOnOffState;
    // debugPrint('In PwmFanService systemOnOffState: $systemOnOffState');
    if (!systemOnOffState) {
      pwm0.disable();
      pwm1.disable();
      pwm2.disable();
      pwm3.disable();
      // debugPrint('In PwmFanService enable: ${pwm.getEnabled()}');
    }
    if (systemOnOffState) {
      pwm0.enable();
      pwm1.enable();
      pwm2.enable();
      pwm3.enable();
      // debugPrint('In PwmFanService enable: ${pwm.getEnabled()}');
    }
  }
} // End of class PwmFanService
