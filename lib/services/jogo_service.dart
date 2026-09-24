import 'package:procura_palavras/services/controlador_audio.dart';
import 'package:procura_palavras/components/caixa_dialogo.dart';
import 'package:flutter/material.dart';

void finalizarJogo(BuildContext context) {
  CaixaDialogo.mostrar(context);
  ControladorAudio.tocarMusica('venceu.mp3');
}
