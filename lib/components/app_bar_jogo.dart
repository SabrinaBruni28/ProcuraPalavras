import 'package:procura_palavras/services/controlador_audio.dart';
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
      centerTitle: true,
      backgroundColor: corAtual,

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

      leading: Navigator.canPop(context)
          ? MouseRegion(
              onEnter: (_) {
                ControladorAudio.tocarEfeito('mouse_houver.mp3');
              },
              child: IconButton(
                onPressed: () {
                  ControladorAudio.tocarEfeito('mouse_click.mp3');
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.white.withValues(alpha: 0.35);
                    }

                    return Colors.transparent;
                  }),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            )
          : null,
    );
  }
}
