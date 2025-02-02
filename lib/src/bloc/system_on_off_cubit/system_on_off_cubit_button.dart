import 'package:bloc/bloc.dart';
import 'package:bme_i2c/src/bloc/repositories/data_repository.dart';
import 'package:bme_i2c/src/services/heater_service.dart';
import 'package:bme_i2c/src/services/heater_service_pid.dart';
import 'package:bme_i2c/src/services/humidifier_service.dart';
import 'package:bme_i2c/src/services/pwm_fan_service.dart';
// import 'package:flutter/foundation.dart';
import 'system_on_off_state_button.dart';

class SystemOnOffCubit extends Cubit<SystemOnOffState> {
  final HeaterService heaterService;
  final HumidifierService humidifierService;
  final HeaterServicePid heaterServicePid;
  final PwmFanService pwmFanService;
  final DataRepository dataRepository;

  SystemOnOffCubit(this.heaterService, this.humidifierService,
      this.heaterServicePid, this.pwmFanService, this.dataRepository)
      : super(SystemOnState());

  void toggleSystemState() {
    if (state is SystemOnState) {
      // debugPrint('In Cubit Turning system off');
      // heaterServicePid.disableHeaterPwmPid();
      humidifierService.humidifierSystemOnOff();
      heaterService.heaterSystemOnOff();
      pwmFanService.pwmFanSystemOnOff();
      dataRepository.updateSystemOnOff(true);
      emit(SystemOffState());
    } else {
      // debugPrint('In Cubit Turning system on');
      // heaterServicePid.enableHeaterPwmPid();
      humidifierService.humidifierSystemOnOff();
      heaterService.heaterSystemOnOff();
      pwmFanService.pwmFanSystemOnOff();
      dataRepository.updateSystemOnOff(false);
      emit(SystemOnState());
    }
  }
}
