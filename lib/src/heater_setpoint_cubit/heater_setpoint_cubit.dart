import 'package:bloc/bloc.dart';
// import 'package:flutter/foundation.dart';
import 'heater_setpoint_state.dart';
import 'package:bme_i2c/src/services/heater_service_pid.dart';

class HeaterSetpointCubit extends Cubit<HeaterSetpointState> {
  final HeaterService heaterService;

  HeaterSetpointCubit(this.heaterService) : super(HeaterSetpointInitial());

  void setHeaterTemperature(double setpoint) {
    // debugPrint('In HeaterSetpointCubit new setpoint: $setpoint');
    heaterService.updateSetpoint(setpoint);
    emit(HeaterSetpointUpdated(setpoint));
  }
}
