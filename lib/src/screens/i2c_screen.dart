import 'package:bme_i2c/src/widgets/data_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bme_i2c/src/i2c_bme280_cubit/i2c_cubit.dart';
import 'package:bme_i2c/src/i2c_bme280_cubit/i2c_state.dart';
import 'package:bme_i2c/src/heater_setpoint_cubit/heater_setpoint_cubit.dart';
import 'package:bme_i2c/src/heater_setpoint_cubit/heater_setpoint_state.dart';
// import 'package:bme_i2c/src/services/heater_service.dart';
import 'package:bme_i2c/src/widgets/heater_setpoint.dart';

class I2CScreen extends StatelessWidget {
  const I2CScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('I2C Sensor Data')),
      body: Column(
        children: [
          BlocBuilder<I2CCubit, I2CState>(
            builder: (context, state) {
              return DataDisplay(
                temperature: state.temperature,
                humidity: state.humidity,
                pressure: state.pressure,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 400,
              height: 50,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Heater Temperature Setpoint',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          HeaterSetpointButton(
            onPressed: () {
              final double? setpoint = double.tryParse(_controller.text);
              if (setpoint != null) {
                context.read<HeaterSetpointCubit>().setHeaterTemperature(setpoint);
              } else {
                debugPrint('Invalid input');
              }
            },
          ),
          BlocBuilder<HeaterSetpointCubit, HeaterSetpointState>(
            builder: (context, state) {
              if (state is HeaterSetpointUpdated) {
                return Text('Setpoint: ${state.setpoint}');
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}