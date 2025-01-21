import 'package:bme_i2c/src/humidity_setpoint_cubit/humidity_setpoint_cubit.dart';
import 'package:bme_i2c/src/services/humidifier_service_pid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bme_i2c/src/screens/i2c_screen.dart';
import 'package:bme_i2c/src/i2c_bme280_cubit/i2c_cubit.dart';
import 'package:bme_i2c/src/services/heater_service_pid.dart';
import 'package:bme_i2c/src/heater_setpoint_cubit/heater_setpoint_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => I2CCubit()..startPolling(),
        ),
        BlocProvider(
          create: (_) => HeaterSetpointCubit(HeaterService()),
        ),
        BlocProvider(
          create: (_) => HumiditySetpointCubit(HumidifierService()),
        ),  
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'I2C Sensor Data',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const I2CScreen(),
      ),
    );
  }
}