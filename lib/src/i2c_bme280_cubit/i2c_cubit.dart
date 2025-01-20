import 'package:bme_i2c/src/services/heater_service.dart';
import 'package:bme_i2c/src/services/i2c_service.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'i2c_state.dart';

class I2CCubit extends Cubit<I2CState> {
  final I2CService i2cService = I2CService();
  final HeaterService heaterService = HeaterService();
  // final HeaterPwmService heaterPwmService = HeaterPwmService();

  I2CCubit()
      : super(const I2CState(temperature: 0.0, humidity: 0.0, pressure: 0.0)) {
    _initialize();
  }

  void _initialize() {
    i2cService.initializeBme280();
    heaterService.initializeHeaterService();
  }

  void startPolling() {
    // debugPrint('In cubit startPolling () method');

    i2cService.startPolling((data) {
      emit(state.copyWith(
        temperature: data['temperature'],
        humidity: data['humidity'],
        pressure: data['pressure'],
      ));
      heaterService.updateTemperature(
      currentTemperature: data['temperature']!);
      // heaterPwmService.updateTemperature(data['temperature']!);
    });
  }
}
