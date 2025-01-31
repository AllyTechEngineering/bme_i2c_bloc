import 'package:bme_i2c/src/bloc/repositories/data_repository.dart';
import 'package:bme_i2c/src/services/heater_service.dart';
import 'package:bme_i2c/src/services/humidifier_service.dart';
import 'package:bme_i2c/src/services/i2c_service.dart';
import 'package:bme_i2c/src/services/level_sense_service.dart';
import 'package:bme_i2c/src/services/pwm_fan_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'i2c_state.dart';

class I2CCubit extends Cubit<I2CState> {
  final I2CService i2cService = I2CService();
  final HeaterService heaterService = HeaterService();
  final HumidifierService humidifierService = HumidifierService();
  final PwmFanService pwmFanService = PwmFanService();
  final LevelSenseService levelSenseService = LevelSenseService();
  final DataRepository dataRepository;

  I2CCubit({required this.dataRepository})
      : super(const I2CState(temperature: 0.0, humidity: 0.0, pressure: 0.0)) {
    _initialize();
  }

  void _initialize() {
    debugPrint('In cubit _initialize () method');
    i2cService.initializeBme280();
    heaterService.initializeHeaterService();
    humidifierService.initializeHumidifierService();
    pwmFanService.initializePwmFanService();
  }

  void startPolling() {
    i2cService.startPolling((data) {
      emit(state.copyWith(
        temperature: data['temperature'],
        humidity: data['humidity'],
        pressure: data['pressure'],
      ));
      heaterService.updateTemperature(currentTemperature: data['temperature']!);
      humidifierService.updateHumidity(currentHumidity: data['humidity']!);

      // Send the updated data to the DataRepository
      dataRepository.sendSensorReadings(
        data['temperature']!,
        data['humidity']!,
        data['pressure']!,
      );
    });
  }
}
