import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget {
  final String label;
  final String value;

  const DataContainer({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text('$label: $value'),
    );
  }
}