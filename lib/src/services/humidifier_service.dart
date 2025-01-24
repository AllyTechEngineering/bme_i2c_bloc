import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HumidifierService {
  final double onHysteresis = 1.0;
  final double offHysteresis = 0.5;
  bool _humidifierState = false;
  static bool systemOnOffState = true;
  static double? _setpointHumidity = 0.0;
  static double? _currentHumidity;

  static GPIO gpio21 = GPIO(21, GPIOdirection.gpioDirOut, 0);

  void initializeHumidifierService() {
    // debugPrint('in initializeHumidifierService');
    try {
      // debugPrint('GPIO 21 Infor: ${gpio21.getGPIOinfo()}');
    } catch (e) {
      gpio21.dispose();
      debugPrint('Init GPIO 21 as output Error: $e');
    }
  }

  void updateSetpoint(double setpoint) {
    _setpointHumidity = setpoint;
    // debugPrint(
    //     'in HumidifierService class: Humidity setpoint updated to: $_setpointHumidity');
  }

  void updateHumidity({required double currentHumidity}) {
    _currentHumidity = currentHumidity;
    updateHumidifierState();
  }

  // Method to update the heater state
  void updateHumidifierState() {
    if (systemOnOffState) {
      if (_currentHumidity! < _setpointHumidity! - onHysteresis) {
        _humidifierState = false; // Relay is active low
        // debugPrint('Humidifier is ON: $_humidifierState');
        // debugPrint('Current Humidity: $_currentHumidity');
        // debugPrint(
        //     'Setpoint for Humidifier ON _currentHumidity - onHysteresis: ${_setpointHumidity! - onHysteresis}');
        // debugPrint(
        //     'Setpoint for Humidifier On _setpointHumidity: ${_setpointHumidity! - offHysteresis}');
        gpio21.write(_humidifierState); // Relay is active low
      } else if (_currentHumidity! > _setpointHumidity! - offHysteresis) {
        _humidifierState = true; //Relay is active low
        //       debugPrint('in updateHeaterState method else if statement $systemOnOffState');
        // debugPrint('System On Off State: $systemOnOffState');
        // debugPrint('Humidifier is OFF: $_humidifierState');
        // debugPrint('Current Humidity: $_currentHumidity');
        // debugPrint(
        //     'Setpoint for Humidifier OFF _setpointHumidity - offHysteresis: ${_setpointHumidity! - offHysteresis}}');
        // debugPrint(
        //     'Setpoint for Humidifier Off Humidity: ${_setpointHumidity! - offHysteresis}');
        gpio21.write(_humidifierState);
      }
    }
  }

  void humidifierSystemOnOff() {
    systemOnOffState = !systemOnOffState;
    // debugPrint(
    //     'in heaterSystemOnOff method System On/Off State: $systemOnOffState');
    if (systemOnOffState == false) {
      gpio21.write(true); //Relay is active low
    }
  }
}
