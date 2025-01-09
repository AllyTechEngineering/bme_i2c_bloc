class I2CState {
  final String temperature;
  final String humidity;
  final String pressure;

  const I2CState({
    required this.temperature,
    required this.humidity,
    required this.pressure,
  });

  I2CState copyWith({
    String? temperature,
    String? humidity,
    String? pressure,
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
