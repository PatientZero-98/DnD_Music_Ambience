import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../services/storage_service.dart';
import '../models/track.dart';

class MoodProvider extends ChangeNotifier {
  final List<Mood> _moods = [];

  List<Mood> get moods => _moods;

  Future<void> loadMoods() async {
    _moods.clear();
    _moods.addAll(await StorageService.loadMoods());
    notifyListeners();
  }

  void addMood(Mood mood) {
    _moods.add(mood);
    StorageService.saveMoods(_moods);
    notifyListeners();
  }

  void updateMood(Mood mood) {
    final idx = _moods.indexWhere((m) => m.name == mood.name);
    if (idx != -1) {
      _moods[idx] = mood;
      StorageService.saveMoods(_moods);
      notifyListeners();
    }
  }

  void addTrackToMood(String moodName, Track track) {
    final idx = _moods.indexWhere((m) => m.name == moodName);
    if (idx != -1) {
      _moods[idx].tracks.add(track);
      StorageService.saveMoods(_moods);
      notifyListeners();
    }
  }

  void deleteMood(String moodName) {
  _moods.removeWhere((mood) => mood.name == moodName);
  StorageService.saveMoods(_moods);
  notifyListeners();
}

}
