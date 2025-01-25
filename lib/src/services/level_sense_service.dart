import 'package:dart_periphery/dart_periphery.dart';

class LevelSenseService {
  static int levelSensePin = 17;
   static Duration pollingDuration = const Duration(milliseconds: 500);
  static Duration debounceDuration = const Duration(milliseconds: 500);
  static GPIO? gpio;
  static bool isLevelDetected = false;
  static bool isPolling = false;
  static bool isDebouncing = false;

  void initializeLevelSenseService() {
    gpio = GPIO(levelSensePin, GPIOdirection.gpioDirIn);
    // isLevelDetected = gpio!.getValue() == 1;
    // isPolling = false;
    // isDebouncing = false;
  }
  void updateLevelSense() {
  }
} //LevelSenseService
