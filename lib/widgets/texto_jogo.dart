import 'package:flutter/material.dart';

class TextoJogo extends StatelessWidget {
  final String texto;
  final double size;

  const TextoJogo({super.key, required this.texto, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
    );
  }
}
