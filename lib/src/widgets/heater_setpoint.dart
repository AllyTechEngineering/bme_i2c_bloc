import 'package:flutter/material.dart';

class HeaterSetpointButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HeaterSetpointButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Set Heater Temperature'),
    );
  }
}