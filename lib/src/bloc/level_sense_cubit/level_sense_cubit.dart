import 'package:bloc/bloc.dart';
import 'package:bme_i2c/src/bloc/repositories/data_repository.dart';
import 'package:bme_i2c/src/services/level_sense_service.dart';
import 'level_sense_state.dart';

class LevelSenseCubit extends Cubit<LevelSenseState> {
  final LevelSenseService levelSenseService;
  final DataRepository dataRepository;

  LevelSenseCubit(this.levelSenseService, this.dataRepository)
      : super(const LevelSenseState(isLevelDetected: false)) {
    _initialize();
  }

  void _initialize() {
    levelSenseService.initializeLevelSenseService();
    levelSenseService.startPolling((isLevelDetected) {
      dataRepository.updateDoughLevel(isLevelDetected);
      emit(state.copyWith(isLevelDetected: isLevelDetected));
    });
  }

  void stopPolling() {
    levelSenseService.stopPolling();
  }
}
