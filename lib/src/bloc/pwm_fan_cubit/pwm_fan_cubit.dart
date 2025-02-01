import 'package:bloc/bloc.dart';
import 'package:bme_i2c/src/bloc/repositories/data_repository.dart';
import 'package:bme_i2c/src/services/pwm_fan_service.dart';
import 'pwm_fan_state.dart';

class PwmFanCubit extends Cubit<PwmFanState> {
  final PwmFanService pwmFanService;
  final DataRepository dataRepository;

  PwmFanCubit(this.pwmFanService, this.dataRepository) : super(PwmFanInitial());

  void setPwmDutyCycle(int dutyCycle) {
    pwmFanService.updatePwmDutyCycle(dutyCycle);
    dataRepository.updateFanSpeed(dutyCycle);
    emit(PwmFanUpdated(dutyCycle));
  }
}
