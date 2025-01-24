import 'package:bloc/bloc.dart';
import 'package:bme_i2c/src/services/pwm_fan_service.dart';
// import 'package:flutter/material.dart';
import 'pwm_fan_state.dart';

class PwmFanCubit extends Cubit<PwmFanState> {
  final PwmFanService pwmFanService;

  PwmFanCubit(this.pwmFanService) : super(PwmFanInitial());

  void setPwmDutyCycle(int dutyCycle) {
    // debugPrint('In PwmFanCubit setPwmDutyCycle DutyCycle= $dutyCycle');
    pwmFanService.updatePwmDutyCycle(dutyCycle);
    emit(PwmFanUpdated(dutyCycle));
  }
}
