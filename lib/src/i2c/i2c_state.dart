class I2CState {
  final double temperature;
  final double humidity;
  final double pressure;

  const I2CState({
    required this.temperature,
    required this.humidity,
    required this.pressure,
  });

  I2CState copyWith({
    double? temperature,
    double? humidity,
    double? pressure,
  }) {
    return I2CState(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
    );
  }

  @override
  String toString() {
    return 'I2CState(temperature: $temperature, humidity: $humidity, pressure: $pressure)';
  }
}
