import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sound_service.g.dart';

@Riverpod(keepAlive: true)
SoundService soundService(Ref ref) {
  return SoundService();
}

class SoundService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSuccess() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/success.mp3'));
    } catch (e) {
      // Ignore errors if asset missing
    }
  }

  Future<void> playFailure() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/failure.mp3'));
    } catch (e) {
      // Ignore errors
    }
  }

  Future<void> playClick() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/click.mp3'));
    } catch (e) {
      // Ignore errors
    }
  }
}
