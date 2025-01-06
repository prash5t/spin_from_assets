import 'package:example/exports.dart';

class SoundService {
  final AudioPlayer _spinPlayer = AudioPlayer();
  final AudioPlayer selectPlayer = AudioPlayer();

  Future<void> playSpinSound(String? soundPath) async {
    if (soundPath == null) return;
    try {
      await _spinPlayer.setReleaseMode(ReleaseMode.loop);
      await _spinPlayer.play(AssetSource(soundPath),
          mode: PlayerMode.lowLatency);
    } catch (e) {
      debugPrint('Error playing spin sound: $e');
    }
  }

  Future<void> playSelectSound(String? soundPath) async {
    if (soundPath == null) return;
    try {
      await selectPlayer.play(AssetSource(soundPath),
          mode: PlayerMode.lowLatency);
    } catch (e) {
      debugPrint('Error playing select sound: $e');
    }
  }

  Future<void> stopSpinSound() async {
    await _spinPlayer.stop();
  }
}
