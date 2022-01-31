import 'package:flutter/material.dart';

class CustumTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const CustumTextInput(
      {required this.controller, required this.label, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
