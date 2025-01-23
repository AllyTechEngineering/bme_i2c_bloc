import 'package:equatable/equatable.dart';

abstract class SystemOnOffState extends Equatable {
  @override
  List<Object> get props => [];
}

class SystemOnState extends SystemOnOffState {
  @override
  String toString() => 'SystemOnState';
}

class SystemOffState extends SystemOnOffState {
  @override
  String toString() => 'SystemOffState';
}