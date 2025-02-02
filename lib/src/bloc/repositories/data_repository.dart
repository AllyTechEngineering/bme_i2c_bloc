import 'dart:async';
import 'package:flutter/foundation.dart';

class DataRepository {
  static final DataRepository _instance = DataRepository._internal();

  factory DataRepository() {
    return _instance;
  }

  DataRepository._internal();
  static double currentTemperature = 0.0;
  static double currentHumidity = 0.0;
  static double currentPressure = 0.0;
  static double setpointHumidity = 0;
  static double setpointTemperature = 0;
  static int fanSpeed = 0;
  static bool systemOnOff = false;
  static String systemStateString = 'off';
  static bool doughLevel = false;
  static String doughLevelString = 'Not Risen';

  final StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get dataStream => _controller.stream;

  void updateData(Map<String, dynamic> updatedData) {
    _controller.add(updatedData);
    debugPrint('In Data Repository updatedData: $updatedData');
  }

  void updateSetpointTemperature(double newSetpointTemperature) {
    setpointTemperature = newSetpointTemperature;
    debugPrint(
        'In Data Repository new setpointTemperature: $setpointTemperature');
  }

  void updateSetpointHumidity(double newSetpointHumidity) {
    setpointHumidity = newSetpointHumidity;
    debugPrint('In Data Repository new setpointHumidity: $setpointHumidity');
  }

  void updateFanSpeed(int newFanSpeed) {
    fanSpeed = newFanSpeed;
    debugPrint('In Data Repository new fanSpeed: $fanSpeed');
  }

  void updateSystemOnOff(bool newSystemOnOff) {
    systemOnOff = newSystemOnOff;
  }

  void updateDoughLevel(bool newDoughLevel) {
    doughLevel = newDoughLevel;
  }

  void sendSensorReadings(
      currentTemperature, currentHumidity, currentPressure) {
    // Package sensor data into a map
    final sensorData = {
      "setpointHumidity": setpointHumidity,
      "setpointTemperature": setpointTemperature,
      "currentTemperature": currentTemperature,
      "currentHumidity": currentHumidity,
      "currentPressure": currentPressure,
      "fanSpeed": fanSpeed,
      "systemOnOff": systemOnOff,
      "doughLevel": doughLevel,
    };

    // Send to stream
    _controller.add(sensorData);

    debugPrint('In Data Repository sensorData: $sensorData');
  }

  void dispose() {
    _controller.close();
  }
}
