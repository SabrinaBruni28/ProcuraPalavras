import 'package:procura_palavras/services/controlador_audio.dart';
import 'package:procura_palavras/widgets/app_bar_jogo.dart';
import 'package:flutter/material.dart';
import 'package:procura_palavras/widgets/texto_jogo.dart';

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

      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 200,
          height: 800,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextoJogo(texto: "Volume"),

                const SizedBox(height: 40),

                // Música
                Row(
                  children: [
                    const Icon(Icons.music_note, size: 30),

                    const SizedBox(width: 15),

                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Música',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Slider(
                        value: volumeMusica,
                        min: 0,
                        max: 1,
                        divisions: 20,
                        label: '${(volumeMusica * 100).round()}%',
                        onChanged: (valor) {
                          setState(() {
                            volumeMusica = valor;
                          });

                          ControladorAudio.alterarVolumeMusica(valor);
                        },
                      ),
                    ),

                    SizedBox(
                      width: 50,
                      child: Text(
                        '${(volumeMusica * 100).round()}%',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Efeitos
                Row(
                  children: [
                    const Icon(Icons.volume_up, size: 30),

                    const SizedBox(width: 15),

                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Efeitos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Slider(
                        value: volumeEfeitos,
                        min: 0,
                        max: 1,
                        divisions: 20,
                        label: '${(volumeEfeitos * 100).round()}%',
                        onChanged: (valor) {
                          setState(() {
                            volumeEfeitos = valor;
                          });

                          ControladorAudio.alterarVolumeEfeitos(valor);
                        },
                      ),
                    ),

                    SizedBox(
                      width: 50,
                      child: Text(
                        '${(volumeEfeitos * 100).round()}%',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
