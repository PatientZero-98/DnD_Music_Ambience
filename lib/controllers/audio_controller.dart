import 'package:just_audio/just_audio.dart';
import '../models/track.dart';

class AudioController {
  final Map<String, AudioPlayer> _players = {};

  Future<void> playTrack(Track track, double volume) async {
    
    if (_players.containsKey(track.id)) {
      await _players[track.id]!.setVolume(volume);
      await _players[track.id]!.play();
    } else {
      final player = AudioPlayer();
      await player.setFilePath(track.path);
      await player.setVolume(volume);
      await player.setLoopMode(LoopMode.one);
      _players[track.id] = player;
      await player.play();
    }
  }

  void setVolume(Track track, double volume) {
    _players[track.id]?.setVolume(volume);
  }

  Future<void> stopTrack(Track track) async {
    await _players[track.id]?.stop();
    await _players[track.id]?.dispose();
    _players.remove(track.id);
  }

  Future<void> stopAll() async {
    for (var player in _players.values) {
      await player.stop();
      await player.dispose();
    }
    _players.clear();
  }
}
