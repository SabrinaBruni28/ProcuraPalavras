import 'package:flutter/material.dart';

Widget textoJogo({required String texto, double size = 30}) {
  return Text(
    texto,
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
  );
}
