import 'package:bloc/bloc.dart';
import 'package:bme_i2c/src/bloc/repositories/data_repository.dart';
import 'heater_setpoint_state.dart';
import 'package:bme_i2c/src/services/heater_service.dart';

class HeaterSetpointCubit extends Cubit<HeaterSetpointState> {
  final HeaterService heaterService;
  final DataRepository dataRepository;

  HeaterSetpointCubit(this.heaterService, this.dataRepository)
      : super(HeaterSetpointInitial());

  void setHeaterTemperature(double setpointTemperature) {
    // debugPrint('In HeaterSetpointCubit new setpointTemperrature: $setpointTemperature');
    heaterService.updateSetpoint(setpointTemperature);
    dataRepository.updateSetpointTemperature(setpointTemperature);
    emit(HeaterSetpointUpdated(setpointTemperature));
  }
}
