import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class ControladorAudio {
  static final AudioPlayer _musica = AudioPlayer();
  static final AudioPlayer _efeitos = AudioPlayer();

  // Volumes gerais
  static double volumeMusica = 0.5;
  static double volumeEfeitos = 1.0;

  // Volumes individuais dos efeitos
  static const Map<String, double> volumesEfeitos = {
    'mouse_clique.mp3': 1.0,
    'mouse_hover.mp3': 1.0,
    'acerto.mp3': 1.0,
    'erro.mp3': 0.4,
  };

  static Future<void> configurar() async {
    await _musica.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          audioFocus: AndroidAudioFocus.none,
          usageType: AndroidUsageType.game,
          contentType: AndroidContentType.music,
        ),
      ),
    );
  }

  static Future<void> carregarVolumes() async {
    final preferencias = await SharedPreferences.getInstance();

    volumeMusica = preferencias.getDouble('volume_musica') ?? 0.5;

    volumeEfeitos = preferencias.getDouble('volume_efeitos') ?? 1.0;
  }

  static Future<void> tocarMusica(String nome) async {
    await _musica.setReleaseMode(ReleaseMode.loop);
    await _musica.setVolume(volumeMusica);

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

    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setDouble('volume_musica', volume);

    await _musica.setVolume(volumeMusica);
  }

  static Future<void> alterarVolumeEfeitos(double volume) async {
    volumeEfeitos = volume;

    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setDouble('volume_efeitos', volume);
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
