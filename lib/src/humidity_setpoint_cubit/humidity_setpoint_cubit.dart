import 'package:bloc/bloc.dart';
import 'package:bme_i2c/src/humidity_setpoint_cubit/humidity_setpoint_state.dart';
import 'package:bme_i2c/src/services/humidifier_service.dart';

import 'package:flutter/foundation.dart';


class HumiditySetpointCubit extends Cubit<HumiditySetpointState> {
  final HumidifierService humidifierService;

  HumiditySetpointCubit(this.humidifierService) : super(HumiditySetpointInitial());

  void setHumidity(double setpointHumidity) {
    debugPrint('In HumdiditySetpointCubit new setpointHumidity: $setpointHumidity');
    humidifierService.updateSetpoint(setpointHumidity);
    emit(HumiditySetpointUpdated(setpointHumidity));
  }
}