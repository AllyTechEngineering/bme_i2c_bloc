import 'package:bme_i2c/src/screens/i2c_screen.dart';
import 'package:flutter/material.dart';

void main() {
  // final i2cService = I2CService(deviceAddress: 0x76);
  // final i2cCubit = I2CCubit(i2cService);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: I2CScreen(),
    );
  }
}
