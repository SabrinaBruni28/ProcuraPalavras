import 'package:procura_palavras/services/controlador_audio.dart';
import 'package:procura_palavras/widgets/botao_jogo.dart';
import 'package:procura_palavras/widgets/texto_jogo.dart';
import 'package:flutter/material.dart';

class CaixaDialogo {
  static void mostrar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícone
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🎉', style: TextStyle(fontSize: 45)),
                  ),
                ),

                const SizedBox(height: 20),

                // Título
                TextoJogo(texto: 'Parabéns!'),

                const SizedBox(height: 12),

                // Mensagem
                TextoJogo(texto: 'Você encontrou todas as palavras!', size: 18),

                const SizedBox(height: 25),

                // Botão
                BotaoJogo(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    ControladorAudio.continuarMusica();
                  },
                  texto: 'Menu',
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
