import 'package:procura_palavras/services/controlador_audio.dart';
import 'package:procura_palavras/components/app_bar_jogo.dart';
import 'package:procura_palavras/widgets/slider_volume.dart';
import 'package:procura_palavras/widgets/texto_jogo.dart';
import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  double volumeMusica = ControladorAudio.volumeMusica;
  double volumeEfeitos = ControladorAudio.volumeEfeitos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarJogo(titulo: 'Configurações'),

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  textoJogo(texto: "Volume", size: 40),

                  const SizedBox(height: 40),

                  // Música
                  sliderVolume(
                    icone: Icons.music_note,
                    titulo: 'Música',
                    volume: volumeMusica,
                    onChanged: (valor) {
                      setState(() {
                        volumeMusica = valor;
                      });

                      ControladorAudio.alterarVolumeMusica(valor);
                    },
                  ),

                  const SizedBox(height: 25),

                  // Efeitos
                  sliderVolume(
                    icone: Icons.volume_up,
                    titulo: 'Efeitos',
                    volume: volumeEfeitos,
                    onChanged: (valor) {
                      setState(() {
                        volumeEfeitos = valor;
                      });

                      ControladorAudio.alterarVolumeEfeitos(valor);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
