import 'package:flutter/material.dart';

Offset? obterCelula(Offset posicao, double tamanho, double tamanhoCelula) {
  if (posicao.dx < 0 ||
      posicao.dy < 0 ||
      posicao.dx >= tamanho ||
      posicao.dy >= tamanho) {
    return null;
  }

  final coluna = (posicao.dx / tamanhoCelula).floor();
  final linha = (posicao.dy / tamanhoCelula).floor();

  return Offset(linha.toDouble(), coluna.toDouble());
}

String? obterPalavraSelecionada(
  List<Offset> selecionadas,
  List<List<String>> matriz,
) {
  if (selecionadas.isEmpty) {
    return null;
  }

  return selecionadas
      .map((posicao) => matriz[posicao.dx.toInt()][posicao.dy.toInt()])
      .join();
}
