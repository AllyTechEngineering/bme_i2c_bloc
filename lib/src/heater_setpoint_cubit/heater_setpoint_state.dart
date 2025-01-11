import 'package:equatable/equatable.dart';

abstract class HeaterSetpointState extends Equatable {
  const HeaterSetpointState();

  @override
  List<Object?> get props => [];
}

class HeaterSetpointInitial extends HeaterSetpointState {}

class HeaterSetpointUpdated extends HeaterSetpointState {
  final double setpoint;

  const HeaterSetpointUpdated(this.setpoint);

  HeaterSetpointUpdated copyWith({double? setpoint}) {
    return HeaterSetpointUpdated(setpoint ?? this.setpoint);
  }

  @override
  List<Object?> get props => [setpoint];
}