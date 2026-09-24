import 'package:procura_palavras/services/controlador_audio.dart';
import 'package:flutter/material.dart';

Widget botaoJogo({
  required String texto,
  required VoidCallback onPressed,
  IconData? icone,
  double size = 25,
}) {
  {
    return MouseRegion(
      onEnter: (_) {
        ControladorAudio.tocarEfeito('mouse_houver.mp3');
      },
      child: ElevatedButton.icon(
        onPressed: () {
          ControladorAudio.tocarEfeito('mouse_click.mp3');
          onPressed();
        },

        icon: icone != null ? Icon(icone) : const SizedBox.shrink(),

        label: Text(texto, style: const TextStyle(color: Colors.black)),

        style: ButtonStyle(
          textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: size, fontWeight: FontWeight.bold),
          ),

          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),

          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.amber.shade400;
            }

            return Colors.amber.shade300;
          }),

          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
