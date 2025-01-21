import 'package:bme_i2c/src/humidity_setpoint_cubit/humidity_setpoint_cubit.dart';
import 'package:bme_i2c/src/humidity_setpoint_cubit/humidity_setpoint_state.dart';
import 'package:bme_i2c/src/widgets/data_display.dart';
import 'package:bme_i2c/src/widgets/humidity_setpoint.dart';
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
    final TextEditingController _setpointTempcontroller =
        TextEditingController();
           // ignore: no_leading_underscores_for_local_identifiers
           final TextEditingController _setpointHumiditycontroller =
        TextEditingController();

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
          TemperatureSetpoint(setpointTempcontroller: _setpointTempcontroller),
          heaterSetpointElevatedButton(_setpointTempcontroller, context),
          heaterSetpointBlocBuilder(),
          HumiditySetpoint(setpointHumiditycontroller: _setpointHumiditycontroller),
          humiditySetpointElevatedButton(_setpointHumiditycontroller, context),
          humiditySetpointBlocBuilder(),
        ],
      ),
    );
  }

  // ignore: no_leading_underscores_for_local_identifiers
  HeaterSetpointButton heaterSetpointElevatedButton(TextEditingController _setpointTempcontroller, BuildContext context) {
    return HeaterSetpointButton(
          onPressed: () {
            final double? setpoint =
                double.tryParse(_setpointTempcontroller.text);
            if (setpoint != null) {
              context
                  .read<HeaterSetpointCubit>()
                  .setHeaterTemperature(setpoint);
            } else {
              debugPrint('Invalid input');
            }
          },
        );
  }

  BlocBuilder<HeaterSetpointCubit, HeaterSetpointState> heaterSetpointBlocBuilder() {
    return BlocBuilder<HeaterSetpointCubit, HeaterSetpointState>(
          builder: (context, state) {
            if (state is HeaterSetpointUpdated) {
              return Text('Setpoint: ${state.setpoint}');
            }
            return Container();
          },
        );
  }

    // ignore: no_leading_underscores_for_local_identifiers
  HumiditySetpointButton humiditySetpointElevatedButton(TextEditingController _setpointHumiditycontroller, BuildContext context) {
    return HumiditySetpointButton(
          onPressed: () {
            final double? setpoint =
                double.tryParse(_setpointHumiditycontroller.text);
            if (setpoint != null) {
              context
                  .read<HumiditySetpointCubit>()
                  .setHumidity(setpoint);
            } else {
              debugPrint('Invalid input');
            }
          },
        );
  }

    BlocBuilder<HumiditySetpointCubit, HumiditySetpointState> humiditySetpointBlocBuilder() {
    return BlocBuilder<HumiditySetpointCubit, HumiditySetpointState>(
          builder: (context, state) {
            if (state is HumiditySetpointUpdated) {
              return Text('Humidity Setpoint: ${state.setpointHumidity}');
            }
            return Container();
          },
        );
  }
}

class TemperatureSetpoint extends StatelessWidget {
  const TemperatureSetpoint({
    super.key,
    required TextEditingController setpointTempcontroller,
  }) : _setpointTempcontroller = setpointTempcontroller;

  final TextEditingController _setpointTempcontroller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 400,
        height: 50,
        child: TextField(
          controller: _setpointTempcontroller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Heater Temperature Setpoint',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
class HumiditySetpoint extends StatelessWidget {
  const HumiditySetpoint({
    super.key,
    required TextEditingController setpointHumiditycontroller,
  }) : _setpointHumiditycontroller = setpointHumiditycontroller;

  final TextEditingController _setpointHumiditycontroller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 400,
        height: 50,
        child: TextField(
          controller: _setpointHumiditycontroller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Humidifier %Setpoint',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
