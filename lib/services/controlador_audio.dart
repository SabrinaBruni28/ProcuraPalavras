import 'package:audioplayers/audioplayers.dart';

class ControladorAudio {
  static final AudioPlayer _musica = AudioPlayer();
  static final AudioPlayer _efeitos = AudioPlayer();

  // Volumes gerais definidos pelo usuário
  static double volumeMusica = 1.0;
  static double volumeEfeitos = 1.0;

  // Volumes individuais dos efeitos
  static const Map<String, double> volumesEfeitos = {
    'mouse_clique.mp3': 1.0,
    'mouse_hover.mp3': 1.0,
    'acerto.mp3': 1.0,
    'erro.mp3': 0.3,
    'vencer.mp3': 0.1,
  };

  static const Map<String, double> volumesMusicas = {'music.mp3': 0.3};

  static Future<void> tocarMusica(String nome) async {
    final volumeIndividual = volumesMusicas[nome] ?? 1.0;

    final volumeFinal = volumeIndividual * volumeMusica;

    await _musica.setReleaseMode(ReleaseMode.loop);
    await _musica.setVolume(volumeFinal);

    await _musica.play(AssetSource('sounds/$nome'));
  }

  static Future<void> tocarEfeito(String nome) async {
    final volumeIndividual = volumesEfeitos[nome] ?? 1.0;

    final volumeFinal = volumeIndividual * volumeEfeitos;

    await _efeitos.setReleaseMode(ReleaseMode.release);

    await _efeitos.setVolume(volumeFinal);

    await _efeitos.play(AssetSource('sounds/$nome'));
  }

  static Future<void> alterarVolumeMusica(double volume) async {
    volumeMusica = volume;

    await _musica.setVolume(volumeMusica);
  }

  static Future<void> alterarVolumeEfeitos(double volume) async {
    volumeEfeitos = volume;
  }

  static Future<void> pararMusica() async {
    await _musica.stop();
  }

  static Future<void> pausarMusica() async {
    await _musica.pause();
  }

  static Future<void> continuarMusica() async {
    await _musica.resume();
  }
}
