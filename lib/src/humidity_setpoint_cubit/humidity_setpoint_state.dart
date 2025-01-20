import 'package:equatable/equatable.dart';

abstract class HumiditySetpointState extends Equatable {
  const HumiditySetpointState();

  @override
  List<Object?> get props => [];
}

class HumiditySetpointInitial extends HumiditySetpointState {}

class HumiditySetpointUpdated extends HumiditySetpointState {
  final double setpointHumidity;

  const HumiditySetpointUpdated(this.setpointHumidity);

  HumiditySetpointUpdated copyWith({double? setpointHumidity}) {
    return HumiditySetpointUpdated(setpointHumidity ?? this.setpointHumidity);
  }

  @override
  List<Object?> get props => [setpointHumidity];
}