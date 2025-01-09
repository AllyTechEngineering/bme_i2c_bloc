import 'package:bme_i2c/blocs/widgets/data_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bme_i2c/blocs/i2c/i2c_cubit.dart';
import 'package:bme_i2c/blocs/i2c/i2c_state.dart';

class I2CScreen extends StatelessWidget {
  const I2CScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => I2CCubit()..startPolling(),
      child: Scaffold(
        appBar: AppBar(title: const Text('I2C Sensor Data')),
        body: BlocBuilder<I2CCubit, I2CState>(
          builder: (context, state) {
            return DataDisplay(
              temperature: state.temperature,
              humidity: state.humidity,
              pressure: state.pressure,
            );
          },
        ),
      ),
    );
  }
}
