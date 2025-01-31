import 'package:bme_i2c/src/bloc/level_sense_cubit/level_sense_cubit.dart';
import 'package:bme_i2c/src/bloc/pwm_fan_cubit/pwm_fan_cubit.dart';
import 'package:bme_i2c/src/bloc/repositories/data_repository.dart';
import 'package:bme_i2c/src/bloc/system_on_off_cubit/system_on_off_cubit_button.dart';
import 'package:bme_i2c/src/humidity_setpoint_cubit/humidity_setpoint_cubit.dart';
import 'package:bme_i2c/src/services/heater_service_pid.dart';
import 'package:bme_i2c/src/services/http_service.dart';
import 'package:bme_i2c/src/services/humidifier_service.dart';
import 'package:bme_i2c/src/services/level_sense_service.dart';
import 'package:bme_i2c/src/services/pwm_fan_service.dart';
// import 'package:bme_i2c/src/services/pwm_sw_fan_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bme_i2c/src/screens/i2c_screen.dart';
import 'package:bme_i2c/src/i2c_bme280_cubit/i2c_cubit.dart';
import 'package:bme_i2c/src/services/heater_service.dart';
import 'package:bme_i2c/src/heater_setpoint_cubit/heater_setpoint_cubit.dart';

void main() {
  final dataRepository = DataRepository();
  debugPrint("Starting Raspberry Pi HTTP Service...");
  HttpService().startServer(); // ✅ Explicitly starts the server
  runApp(MyApp(dataRepository: dataRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.dataRepository});
  final DataRepository dataRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              I2CCubit(dataRepository: dataRepository)..startPolling(),
        ),
        BlocProvider(
          create: (_) => HeaterSetpointCubit(HeaterService()),
        ),
        BlocProvider(
          create: (_) => HumiditySetpointCubit(HumidifierService()),
        ),
        BlocProvider(
          create: (_) => SystemOnOffCubit(HeaterService(), HumidifierService(),
              HeaterServicePid(), PwmFanService()),
        ),
        BlocProvider(
          create: (_) => PwmFanCubit(PwmFanService()),
        ),
        BlocProvider(
          create: (_) => LevelSenseCubit(LevelSenseService()),
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
