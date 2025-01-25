import 'package:equatable/equatable.dart';

class LevelSenseState extends Equatable {
  final bool isLevelDetected;

  const LevelSenseState({required this.isLevelDetected});

  LevelSenseState copyWith({bool? isLevelDetected}) {
    return LevelSenseState(
      isLevelDetected: isLevelDetected ?? this.isLevelDetected,
    );
  }

  @override
  List<Object?> get props => [isLevelDetected];

  @override
  String toString() => 'LevelSenseState(isLevelDetected: $isLevelDetected)';
}