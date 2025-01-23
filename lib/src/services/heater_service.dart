import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HeaterService {
  final double hysteresis = 2.0;
  final double onHysteresis = 2.0;
  final double offHysteresis = 1.0;
  bool _heaterState = false;
  static double? _setpointTemperature = 0.0;
  static double? _currentTemperature;
  static bool systemOnOffState = true;
  static GPIO gpio20 = GPIO(20, GPIOdirection.gpioDirOut, 0);

  void initializeHeaterService() {
    debugPrint('in initializeHeaterService');
    try {
      // debugPrint('GPIO 20 Infor: ${gpio20.getGPIOinfo()}');
    } catch (e) {
      gpio20.dispose();
      debugPrint('Init GPIO 20 as output Error: $e');
    }
  }

  void updateSetpoint(double setpoint) {
    _setpointTemperature = setpoint;
    // debugPrint(
    //     'in HeaterService class: Heater setpoint updated to: $_setpointTemperature');
  }

  void updateTemperature({required double currentTemperature}) {
    _currentTemperature = currentTemperature;
    // debugPrint(
    //     'in HeaterService class: Current temperature updated to: $_currentTemperature');
    updateHeaterState();
  }

  // Method to update the heater state
  void updateHeaterState() {
    if (systemOnOffState) {
      debugPrint('in updateHeaterState method first if statement $systemOnOffState');
      if (_currentTemperature! < _setpointTemperature! - onHysteresis) {
        _heaterState = false;
      debugPrint('in updateHeaterState method second if statement $systemOnOffState');
        // debugPrint('Heater is ON: $_heaterState');
        // debugPrint('Current Temperature: $_currentTemperature');
        // debugPrint(
        //     'Setpoint for Heater ON Temperature - onHysteresis: ${_setpointTemperature! - hysteresis}');
        // debugPrint(
        //     'Setpoint for Heater Off Temperature: ${_setpointTemperature! - offHysteresis}');
        gpio20.write(_heaterState);
      } else if (_currentTemperature! > _setpointTemperature! - offHysteresis) {
        _heaterState = true;
              debugPrint('in updateHeaterState method else if statement $systemOnOffState');
        // debugPrint('System On Off State: $_systemOnOffstate');
        // debugPrint('Heater is OFF: $_heaterState');
        // debugPrint('Current Temperature: $_currentTemperature');
        // debugPrint(
        //     'Setpoint for Heater ON Temperature - hysteresis: $_setpointTemperature! - hysteresis}');
        // debugPrint(
        //     'Setpoint for Heater Off Temperature: ${_setpointTemperature! - offHysteresis}');
        gpio20.write(_heaterState);
      }
    }
  }

  bool heaterSystemOnOff() {
    systemOnOffState = !systemOnOffState;
    debugPrint(
        'in heaterSystemOnOff method System On/Off State: $systemOnOffState');
    if (systemOnOffState == false) {
      gpio20.write(true);
    }
    return systemOnOffState;
  }
}
