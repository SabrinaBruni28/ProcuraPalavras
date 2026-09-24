import 'package:procura_palavras/services/controlador_audio.dart';
import 'package:flutter/widgets.dart';

class ControladorCicloVida with WidgetsBindingObserver {
  void iniciar() {
    WidgetsBinding.instance.addObserver(this);
  }

  void finalizar() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        ControladorAudio.continuarMusica();
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ControladorAudio.pausarMusica();
        break;

      case AppLifecycleState.detached:
        ControladorAudio.pararMusica();
        break;
    }
  }
}
