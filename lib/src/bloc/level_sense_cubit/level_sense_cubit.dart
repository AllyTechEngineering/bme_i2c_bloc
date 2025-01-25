import 'package:bloc/bloc.dart';
import 'package:bme_i2c/src/services/level_sense_service.dart';
import 'level_sense_state.dart';

class LevelSenseCubit extends Cubit<LevelSenseState> {
  final LevelSenseService levelSenseService;

  LevelSenseCubit(this.levelSenseService)
      : super(const LevelSenseState(isLevelDetected: false)) {
    _initialize();
  }

  void _initialize() {
    levelSenseService.initializeLevelSenseService();
    levelSenseService.startPolling((isLevelDetected) {
      emit(state.copyWith(isLevelDetected: isLevelDetected));
    });
  }

  void stopPolling() {
    levelSenseService.stopPolling();
  }
}
