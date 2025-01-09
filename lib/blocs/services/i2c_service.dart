import 'dart:async';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class I2CService {
  final I2C i2c = I2C(1);
  Duration pollingInterval = const Duration(seconds: 1);
  late Timer _pollingTimer;
  late final BME280 bme280;
  bool _isInitialized = false;

  void initializeBme280() {
    try {
      debugPrint('I2C info: ${i2c.getI2Cinfo()}');
      bme280 = BME280(i2c);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing I2C device: $e');
    }
  }

  void stopPolling() {
    _pollingTimer.cancel();
  }

  Future<Map<String, String>> readSensorData() async {
    if (!_isInitialized) {
      throw Exception('BME280 not initialized. Call initializeBme280() first.');
    }
    dynamic getBme280Data;
    try {
      getBme280Data = bme280.getValues();
    } catch (e) {
      debugPrint('Error reading sensor data: $e');
      return {
        'temperature': 'N/A',
        'humidity': 'N/A',
        'pressure': 'N/A',
      };
    }
    final temperature = getBme280Data.temperature.toStringAsFixed(1);
    final humidity = getBme280Data.humidity.toStringAsFixed(1);
    final pressure = getBme280Data.pressure.toStringAsFixed(1);
    return {
      'temperature': temperature,
      'humidity': humidity,
      'pressure': pressure,
    };
  }

  void startPolling(Function(Map<String, String>) onData) {
    _pollingTimer = Timer.periodic(pollingInterval, (_) async {
      try {
        final data = await readSensorData();
        onData(data);
      } catch (e) {
        debugPrint('Error polling I2C device: $e');
      }
    });
  }

  void dispose() {
    stopPolling();
    i2c.dispose();
  }

  // void setPollingInterval(Duration interval) {
  //   pollingInterval = interval;
  //   if (_pollingTimer.isActive) {
  //     stopPolling();
  //     startPolling((_) {});
  //   }
  // }
}
