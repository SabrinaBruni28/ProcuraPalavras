import 'package:flutter/material.dart';

import 'dart:async';

class AppBarJogo extends StatefulWidget implements PreferredSizeWidget {
  final String titulo;

  const AppBarJogo({super.key, required this.titulo});

  @override
  State<AppBarJogo> createState() => _AppBarJogoState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarJogoState extends State<AppBarJogo> {
  final List<Color> cores = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.green,
  ];

  int indiceCor = 0;
  double progresso = 0.0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {
        progresso += 0.01;

        if (progresso >= 1.0) {
          progresso = 0.0;
          indiceCor = (indiceCor + 1) % cores.length;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Color get corAtual {
    final proximaCor = (indiceCor + 1) % cores.length;

    return Color.lerp(cores[indiceCor], cores[proximaCor], progresso)!;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          widget.titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      centerTitle: true,
      backgroundColor: corAtual,
    );
  }
}
