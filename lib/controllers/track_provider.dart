import 'package:flutter/material.dart';
import '../models/track.dart';
import '../services/storage_service.dart';

class TrackProvider extends ChangeNotifier {
  List<Track> _tracks = [];

  List<Track> get tracks => _tracks;

  Future<void> loadTracks() async {
    _tracks = await StorageService.loadTracks();
    notifyListeners();
  }

  void addTrack(Track track) {
    _tracks.add(track);
    try {
      StorageService.saveTracks(_tracks);
      notifyListeners();
    } catch (e) {
      _tracks.remove(track); // Rollback
      rethrow; // Mostra l'errore nell'UI
    }
  }

  void addTracks(List<Track> newTracks) {
    for (var track in newTracks) {
      final alreadyExists = _tracks.any((t) => t.name == track.name);
      if (!alreadyExists) {
        _tracks.add(track);
      }
    }
    saveTracks();
    notifyListeners();
  }

  void saveTracks() {
    StorageService.saveTracks(_tracks);
  }
}
