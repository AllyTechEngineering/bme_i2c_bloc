import 'dart:async';

import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class PwmSwFanService {
  static GPIO gpio13 =
      GPIO(13, GPIOdirection.gpioDirOut, 0); // GPIO setup as static
  static const int period = 1000000; // Period in nanoseconds (constant)
  int dutyCycle = 0; // Duty cycle percentage (0-100)
  bool systemOnOffState = false; // System state (ON/OFF)

  Timer? _pwmTimer; // Timer to handle the software PWM signal
  initializePwmSwFanService() {
    debugPrint('GPIO 13 Infor: ${gpio13.getGPIOinfo()}');
  }

  /// Updates the duty cycle and adjusts the high/low times accordingly
  void updatePwmSwFanDutyCycle(int updatedDutyCycle) {
    dutyCycle =
        updatedDutyCycle.clamp(0, 100); // Clamp duty cycle between 0-100

    if (systemOnOffState) {
      _startPwm(); // Restart PWM with updated duty cycle if the system is ON
    } else {
      gpio13.write(false); // Ensure the fan is OFF if the system is OFF
    }
  }

  /// Toggles the system ON/OFF
  void pwmSwFanSystemOnOff() {
    systemOnOffState = !systemOnOffState;
    if (systemOnOffState) {
      _startPwm(); // Start PWM if the system is ON
    } else {
      _stopPwm(); // Stop PWM if the system is OFF
    }
  }

  /// Starts the software PWM
  void _startPwm() {
    // Cancel any existing PWM timer before starting a new one
    _stopPwm();

    // Avoid running if duty cycle is 0 (fan OFF) or 100 (fan ON continuously)
    if (dutyCycle == 0) {
      gpio13.write(false); // Fan OFF
      return;
    }
    if (dutyCycle == 100) {
      gpio13.write(true); // Fan ON continuously
      return;
    }

    // Start PWM with periodic timer
    _pwmTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      int highTime =
          (period * dutyCycle) ~/ 100; // Calculate high time in nanoseconds
      int lowTime = period - highTime; // Calculate low time in nanoseconds

      // Write HIGH and LOW based on the duty cycle
      gpio13.write(true); // GPIO HIGH
      Future.delayed(Duration(microseconds: highTime), () {
        gpio13.write(false); // GPIO LOW
      });

      // Wait for the low time before the next cycle
      Future.delayed(Duration(microseconds: lowTime), () {});
    });
  }

  /// Stops the software PWM
  void _stopPwm() {
    _pwmTimer?.cancel();
    gpio13.write(false); // Ensure the fan is OFF
  }
}
