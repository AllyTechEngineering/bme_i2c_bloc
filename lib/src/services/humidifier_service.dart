import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HumidifierService {
  final double hysteresis = 2.0;
  final double onHysteresis = 2.0;
  final double offHysteresis = 1.0;
  bool _humidifierState = false;
  bool _systemOnOffstate = true;
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
      if (_currentHumidity! < _setpointHumidity! - onHysteresis) {
        _humidifierState = false;
        // debugPrint('Inside if Loop. System On Off State: $_systemOnOffstate');
        // debugPrint('Humidifier is ON: $_humidifierState');
        // debugPrint('Current Humidity: $_currentHumidity');
        // debugPrint(
        //     'Setpoint for Humidifier ON Humidity - onHysteresis: ${_setpointHumidity! - hysteresis}');
        // debugPrint(
        //     'Setpoint for Humidifier Off Humidity: ${_setpointHumidity! - offHysteresis}');
        gpio21.write(_humidifierState);
      } else if (_currentHumidity! > _setpointHumidity! - offHysteresis) {
        _humidifierState = true;
        // debugPrint('System On Off State: $_systemOnOffstate');
        // debugPrint('Humidifier is OFF: $_humidifierState');
        // debugPrint('Current Humidity: $_currentHumidity');
        // debugPrint(
        //     'Setpoint for Humidifier Off: Humidity - hysteresis: $_setpointHumidity! - hysteresis}');
        // debugPrint(
        //     'Setpoint for Humidifier Off: ${_setpointHumidity! - offHysteresis}');
        gpio21.write(_humidifierState);
      }
    
  }

  void humidifierSystemOn() {
    _systemOnOffstate = true;
    // debugPrint('Turn on Humidifier System _systemOnOffstate = $_systemOnOffstate');
  }

  void humidifierSystemOff() {
    // debugPrint('Set GPIO21 High = Relay Off');
    _systemOnOffstate = false;
    // debugPrint('Turn off Humidifier System _systemOnOffstate = $_systemOnOffstate');
    try {
      gpio21.write(true);
    } catch (e) {
      debugPrint('Error in GPIO 21: $e');
    }
  }
}
