import 'package:flutter/material.dart';

class HumiditySetpointButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HumiditySetpointButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Set Humidifier %'),
    );
  }
}