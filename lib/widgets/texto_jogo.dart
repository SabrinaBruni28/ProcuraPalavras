import 'package:flutter/material.dart';

class TextoJogo extends StatelessWidget {
  final String texto;

  const TextoJogo({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
