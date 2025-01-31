import 'dart:async';
import 'package:flutter/foundation.dart';

class DataRepository {
  static final DataRepository _instance = DataRepository._internal();

  factory DataRepository() {
    return _instance;
  }

  DataRepository._internal();

  final StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get dataStream => _controller.stream;

  void updateData(Map<String, dynamic> updatedData) {
    _controller.add(updatedData);
  }

  void sendSensorReadings(
      double temperature, double humidity, double pressure) {
    // Package sensor data into a map
    final sensorData = {
      "currentTemperature": temperature,
      "currentHumidity": humidity,
      "pressure": pressure // Include if needed
    };

    // Send to stream
    _controller.add(sensorData);

    debugPrint('In Data Repository sensorData: $sensorData');
  }

  void dispose() {
    _controller.close();
  }
}
