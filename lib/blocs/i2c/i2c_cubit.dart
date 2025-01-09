import 'package:bme_i2c/blocs/services/heater_pwm_service.dart';
import 'package:bme_i2c/blocs/services/i2c_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'i2c_state.dart';

class I2CCubit extends Cubit<I2CState> {
  final I2CService i2cService = I2CService();
  final HeaterPwmService heaterPwmService = HeaterPwmService();

  I2CCubit()
      : super(const I2CState(
            temperature: '0.0', humidity: '0.0', pressure: '0.0')) {
    _initialize();
  }

  void _initialize() {
    // debugPrint('In _initialize () method');
    i2cService.initializeBme280();
    // Start polling or other initialization tasks
  }

  // void readSensorData() async {
  //   final data = await i2cService.readSensorData();
  //   emit(state.copyWith(
  //     temperature: data['temperature'],
  //     humidity: data['humidity'],
  //     pressure: data['pressure'],
  //   ));
  //   debugPrint('in cubit Temperature data: ${data['temperature']}');
    
  // }

  void startPolling() {
    debugPrint('In cubit startPolling () method');
    i2cService.startPolling((data) {
      emit(state.copyWith(
        temperature: data['temperature'],
        humidity: data['humidity'],
        pressure: data['pressure'],
      ));
      heaterPwmService.updateTemperature(data['temperature']!);
    });
  }

  void stopPolling() {
    i2cService.stopPolling();
  }

  // void setPollingInterval(Duration interval) {
  //   i2cService.setPollingInterval(interval);
  // }

  @override
  Future<void> close() {
    i2cService.dispose();
    return super.close();
  }

  // String get currentTemperature => state.temperature;
}
