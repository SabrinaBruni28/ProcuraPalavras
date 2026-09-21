import 'package:flutter/material.dart';

class PalavrasPainter extends CustomPainter {
  final Map<String, List<Offset>> palavrasEncontradas;
  final double tamanhoCelula;
  final List<Color> cores;

  PalavrasPainter({
    required this.palavrasEncontradas,
    required this.tamanhoCelula,
    required this.cores,
  });

  @override
  void paint(Canvas canvas, Size size) {
    int indice = 0;

    for (final posicoes in palavrasEncontradas.values) {
      if (posicoes.isEmpty) continue;

      final paint = Paint()
        ..color = cores[indice % cores.length]
        ..strokeWidth = tamanhoCelula * 0.65
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final pontos = posicoes.map((posicao) {
        return Offset(
          posicao.dy * tamanhoCelula + tamanhoCelula / 2,
          posicao.dx * tamanhoCelula + tamanhoCelula / 2,
        );
      }).toList();

      if (pontos.length == 1) {
        canvas.drawCircle(pontos.first, tamanhoCelula * 0.325, paint);
      } else {
        final path = Path()..moveTo(pontos.first.dx, pontos.first.dy);

        for (int i = 1; i < pontos.length; i++) {
          path.lineTo(pontos[i].dx, pontos[i].dy);
        }

        canvas.drawPath(path, paint);
      }

      indice++;
    }
  }

  @override
  bool shouldRepaint(covariant PalavrasPainter oldDelegate) {
    return oldDelegate.palavrasEncontradas != palavrasEncontradas;
  }
}
