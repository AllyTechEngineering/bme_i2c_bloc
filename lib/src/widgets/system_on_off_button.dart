import 'package:bme_i2c/src/bloc/system_on_off_cubit/system_on_off_cubit_button.dart';
import 'package:bme_i2c/src/bloc/system_on_off_cubit/system_on_off_state_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SystemOnOffButton extends StatelessWidget {
  const SystemOnOffButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SystemOnOffCubit, SystemOnOffState>(
        builder: (context, state) {
          final buttonText = state is SystemOnState ? 'System On' : 'System Off';
          return ElevatedButton(
            onPressed: () => context.read<SystemOnOffCubit>().toggleSystemState(),
            child: Text(buttonText),
          );
        },
      ),
    );
  }
}