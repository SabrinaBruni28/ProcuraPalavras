import 'package:flutter/material.dart';

class SelecaoPainter extends CustomPainter {
  final List<Offset> selecionadas;
  final double tamanhoCelula;

  SelecaoPainter({required this.selecionadas, required this.tamanhoCelula});

  @override
  void paint(Canvas canvas, Size size) {
    if (selecionadas.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.5)
      ..strokeWidth = tamanhoCelula * 0.65
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final pontos = selecionadas.map((posicao) {
      return Offset(
        posicao.dy * tamanhoCelula + tamanhoCelula / 2,
        posicao.dx * tamanhoCelula + tamanhoCelula / 2,
      );
    }).toList();

    if (pontos.length == 1) {
      canvas.drawCircle(pontos.first, tamanhoCelula * 0.325, paint);

      return;
    }

    final path = Path()..moveTo(pontos.first.dx, pontos.first.dy);

    for (int i = 1; i < pontos.length; i++) {
      path.lineTo(pontos[i].dx, pontos[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SelecaoPainter oldDelegate) {
    return true;
  }
}
