import 'package:bme_i2c/src/humidity_setpoint_cubit/humidity_setpoint_cubit.dart';
import 'package:bme_i2c/src/humidity_setpoint_cubit/humidity_setpoint_state.dart';
import 'package:bme_i2c/src/widgets/data_display.dart';
import 'package:bme_i2c/src/widgets/humidity_setpoint.dart';
import 'package:bme_i2c/src/widgets/system_on_off_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bme_i2c/src/i2c_bme280_cubit/i2c_cubit.dart';
import 'package:bme_i2c/src/i2c_bme280_cubit/i2c_state.dart';
import 'package:bme_i2c/src/heater_setpoint_cubit/heater_setpoint_cubit.dart';
import 'package:bme_i2c/src/heater_setpoint_cubit/heater_setpoint_state.dart';
// import 'package:bme_i2c/src/services/heater_service.dart';
import 'package:bme_i2c/src/widgets/heater_setpoint.dart';
import 'package:bme_i2c/src/bloc/pwm_fan_cubit/pwm_fan_cubit.dart';
import 'package:bme_i2c/src/bloc/pwm_fan_cubit/pwm_fan_state.dart';

class I2CScreen extends StatelessWidget {
  const I2CScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // // ignore: no_leading_underscores_for_local_identifiers
    // final TextEditingController _setpointTempcontroller =
    //     TextEditingController();
    // // ignore: no_leading_underscores_for_local_identifiers
    // final TextEditingController _setpointHumiditycontroller =
    //     TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Dough Proofer')),
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
          temperatureSetpointSlider(context),
          humiditySetpointSlider(context),
          pwmFanSlider(context),
          systemOnOffButton(),
        ],
      ),
    );
  }

  Widget temperatureSetpointSlider(BuildContext context) {
    return BlocBuilder<HeaterSetpointCubit, HeaterSetpointState>(
      builder: (context, state) {
        double currentValue = 0;
        if (state is HeaterSetpointUpdated) {
          currentValue = state.setpoint;
        }
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text('Temperature Setpoint: ${currentValue.toStringAsFixed(0)} °C'),
            SizedBox(
              width: 300,
              child: Slider(
                value: currentValue,
                min: 0,
                max: 100,
                divisions: 100,
                label: currentValue.round().toString(),
                onChanged: (double value) {
                  context
                      .read<HeaterSetpointCubit>()
                      .setHeaterTemperature(value);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget humiditySetpointSlider(BuildContext context) {
    return BlocBuilder<HumiditySetpointCubit, HumiditySetpointState>(
      builder: (context, state) {
        double currentValue = 0;
        if (state is HumiditySetpointUpdated) {
          currentValue = state.setpointHumidity;
        }
        return Column(
          children: [
            Text('Humidity Setpoint: ${currentValue.toStringAsFixed(0)} %'),
            SizedBox(
              width: 300,
              child: Slider(
                value: currentValue,
                min: 0,
                max: 100,
                divisions: 100,
                label: currentValue.round().toString(),
                onChanged: (double value) {
                  context.read<HumiditySetpointCubit>().setHumidity(value);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  SystemOnOffButton systemOnOffButton() {
    return const SystemOnOffButton();
  }

  Widget pwmFanSlider(BuildContext context) {
    return BlocBuilder<PwmFanCubit, PwmFanState>(
      builder: (context, state) {
        double currentValue = 0;
        if (state is PwmFanUpdated) {
          currentValue = state.dutyCycle.toDouble();
        }
        return Column(
          children: [
            Text('Fan Speed: ${currentValue.toStringAsFixed(0)} %'),
            SizedBox(
              width: 300,
              child: Slider(
                value: currentValue,
                min: 0,
                max: 100,
                divisions: 100,
                label: currentValue.round().toString(),
                onChanged: (double value) {
                  context.read<PwmFanCubit>().setPwmDutyCycle(value.toInt());
                },
              ),
            ),
          ],
        );
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
        width: 200,
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
        width: 200,
        height: 50,
        child: TextField(
          controller: _setpointHumiditycontroller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Humidifier % Setpoint',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
 // HeaterSetpointButton heaterSetpointElevatedButton(
  //     // ignore: no_leading_underscores_for_local_identifiers
  //     TextEditingController _setpointTempcontroller,
  //     BuildContext context) {
  //   return HeaterSetpointButton(
  //     onPressed: () {
  //       final double? setpoint = double.tryParse(_setpointTempcontroller.text);
  //       if (setpoint != null) {
  //         debugPrint('i2c_screen Heater setpoint: $setpoint');
  //         context.read<HeaterSetpointCubit>().setHeaterTemperature(setpoint);
  //       } else {
  //         debugPrint('Invalid input');
  //       }
  //     },
  //   );
  // }

  // BlocBuilder<HeaterSetpointCubit, HeaterSetpointState>
  //     heaterSetpointBlocBuilder() {
  //   return BlocBuilder<HeaterSetpointCubit, HeaterSetpointState>(
  //     builder: (context, state) {
  //       if (state is HeaterSetpointUpdated) {
  //         return Text('Setpoint: ${state.setpoint}');
  //       }
  //       return Container();
  //     },
  //   );
  // }

  // HumiditySetpointButton humiditySetpointElevatedButton(
  //     // ignore: no_leading_underscores_for_local_identifiers
  //     TextEditingController _setpointHumiditycontroller,
  //     BuildContext context) {
  //   return HumiditySetpointButton(
  //     onPressed: () {
  //       final double? setpoint =
  //           double.tryParse(_setpointHumiditycontroller.text);
  //       if (setpoint != null) {
  //         context.read<HumiditySetpointCubit>().setHumidity(setpoint);
  //       } else {
  //         debugPrint('Invalid input');
  //       }
  //     },
  //   );
  // }

  // BlocBuilder<HumiditySetpointCubit, HumiditySetpointState>
  //     humiditySetpointBlocBuilder() {
  //   return BlocBuilder<HumiditySetpointCubit, HumiditySetpointState>(
  //     builder: (context, state) {
  //       if (state is HumiditySetpointUpdated) {
  //         return Text('Humidity Setpoint: ${state.setpointHumidity}');
  //       }
  //       return Container();
  //     },
  //   );
  // }