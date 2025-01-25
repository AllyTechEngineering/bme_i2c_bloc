import 'package:dart_periphery/dart_periphery.dart';
import 'dart:async';

class LevelSenseService {
  static int levelSensePin = 16;
  static Duration pollingDuration = const Duration(milliseconds: 1000);
  static GPIO? gpio;
  static bool isLevelDetected = false;
  static bool isPolling = false;
  static bool currentLevel = false;
  Timer? _pollingTimer;

  void initializeLevelSenseService() {
    gpio = GPIO(levelSensePin, GPIOdirection.gpioDirIn);
  }

  void startPolling(Function(bool) onData) {
    if (isPolling) return;
    isPolling = true;
    _pollingTimer = Timer.periodic(pollingDuration, (_) {
      currentLevel = gpio!.read();
      if (currentLevel != isLevelDetected) {
        isLevelDetected = currentLevel;
        onData(isLevelDetected);
      }
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    isPolling = false;
  }
}
