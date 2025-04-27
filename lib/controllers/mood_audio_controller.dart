import 'package:just_audio/just_audio.dart';
import '../models/mood.dart';
import 'dart:async';

class MoodAudioController {
  final Map<String, AudioPlayer> _players = {}; // moodName -> player
  final Map<String, int> _trackIndices = {}; // moodName -> current track index
  final Map<String, Mood> _moods = {}; // moodName -> mood data
  String? _currentMoodName;
  Timer? _fadeTimer;

  void registerMood(Mood mood) {
    _moods[mood.name] = mood;
    _trackIndices[mood.name] = 0;
    final player = AudioPlayer();

    // Registra una sola volta il listener di fine traccia
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed &&
          _currentMoodName == mood.name) {
        _nextTrack(mood.name);
      }
    });

    _players[mood.name] = player;
  }

  Future<void> setMoodVolume(String moodName, double volume) async {
    if (!_players.containsKey(moodName)) return;

    final player = _players[moodName]!;

    if (volume == 0.0) {
      // Se volume a 0 ➔ PAUSA il mood
      await _fadeOutAndPause(moodName);
      if (_currentMoodName == moodName) _currentMoodName = null;
      return;
    }

    // Se cambio mood attivo
    if (_currentMoodName != null && _currentMoodName != moodName) {
      await _fadeOutAndPause(_currentMoodName!);
    }

    _currentMoodName = moodName;

    // Se il player non sta suonando ➔ Avvia la traccia
    if (!player.playing) {
      final index = _trackIndices[moodName] ?? 0;
      await _playTrackForMood(moodName, index);
    }

    // Aggiorna il volume in ogni caso
    await player.setVolume(volume);
  }

  Future<void> _playTrackForMood(String moodName, int index) async {
  final mood = _moods[moodName]!;
  final player = _players[moodName]!;

  if (mood.tracks.isEmpty) return;

  final track = mood.tracks[index % mood.tracks.length];

  print('▶️ Playing track: ${track.name}'); // DEBUG stampiamo la traccia!

  await player.stop(); // <<< IMPORTANTE stop player prima di caricare nuova traccia
  await player.setFilePath(track.path);
  await player.setVolume(1.0); // Volumi iniziali pieni
  await player.play();
}


  Future<void> _nextTrack(String moodName) async {
    final mood = _moods[moodName]!;
    _trackIndices[moodName] =
        (_trackIndices[moodName]! + 1) % mood.tracks.length;
    await _playTrackForMood(moodName, _trackIndices[moodName]!);
  }

  Future<void> _fadeOutAndPause(String moodName) async {
    if (!_players.containsKey(moodName)) return;
    final player = _players[moodName]!;

    double currentVolume = await player.volume;
    _fadeTimer?.cancel();

    _fadeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      currentVolume -= 0.05;
      if (currentVolume <= 0.0) {
        await player.setVolume(0.0);
        await player.pause();
        timer.cancel();
      } else {
        await player.setVolume(currentVolume);
      }
    });
  }

  Future<void> dispose() async {
    for (var p in _players.values) {
      await p.dispose();
    }
    _fadeTimer?.cancel();
  }
}
