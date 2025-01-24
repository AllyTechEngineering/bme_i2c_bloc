import 'package:equatable/equatable.dart';

abstract class PwmFanState extends Equatable {
  @override
  List<Object> get props => [];
}

class PwmFanInitial extends PwmFanState {}

class PwmFanUpdated extends PwmFanState {
  final int dutyCycle;

  PwmFanUpdated(this.dutyCycle);

  @override
  List<Object> get props => [dutyCycle];

  PwmFanUpdated copyWith({int? dutyCycle}) {
    return PwmFanUpdated(dutyCycle ?? this.dutyCycle);
  }

  @override
  String toString() => 'PwmFanUpdated(dutyCycle: $dutyCycle)';
}