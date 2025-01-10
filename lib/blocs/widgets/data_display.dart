import 'package:bme_i2c/blocs/widgets/data_container.dart';
import 'package:flutter/material.dart';

class DataDisplay extends StatelessWidget {
  final double temperature;
  final double humidity;
  final double pressure;

  const DataDisplay({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.pressure,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DataContainer(label: 'Temperature', value: '${temperature.toStringAsFixed(2)} °C'),
          const SizedBox(height: 10),
          DataContainer(label: 'Humidity', value: '${humidity.toStringAsFixed(2)} %'),
          const SizedBox(height: 10),
          DataContainer(label: 'Pressure', value: '${pressure.toStringAsFixed(2)} hPa'),
        ],
      ),
    );
  }
}
