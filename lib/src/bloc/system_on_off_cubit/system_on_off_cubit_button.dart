import 'package:bloc/bloc.dart';
import 'package:bme_i2c/src/services/heater_service.dart';
import 'package:bme_i2c/src/services/heater_service_pid.dart';
import 'package:bme_i2c/src/services/humidifier_service.dart';
import 'package:flutter/foundation.dart';
import 'system_on_off_state_button.dart';

class SystemOnOffCubit extends Cubit<SystemOnOffState> {
  final HeaterService heaterService;
  final HumidifierService humidifierService;
  final HeaterServicePid heaterServicePid;

  SystemOnOffCubit(
      this.heaterService, this.humidifierService, this.heaterServicePid)
      : super(SystemOnState());

  void toggleSystemState() {
    if (state is SystemOnState) {
      debugPrint('Turning system off');
      // heaterServicePid.disableHeaterPwmPid();
      // humidifierService.humidifierSystemOff();
      heaterService.heaterSystemOnOff();
      emit(SystemOffState());
    } else {
      debugPrint('Turning system on');
      // heaterServicePid.enableHeaterPwmPid();
      // humidifierService.humidifierSystemOn();
      heaterService.heaterSystemOnOff();
      emit(SystemOnState());
    }
  }
}
