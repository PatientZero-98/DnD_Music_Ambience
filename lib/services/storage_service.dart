import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/track.dart';
import '../models/mood.dart';

class StorageService {
  // Percorsi dei file
  static Future<File> get _tracksFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/tracks.json');
  }

  static Future<File> get _moodsFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/moods.json');
  }

  // Tracks
  static Future<List<Track>> loadTracks() async {
    try {
      final file = await _tracksFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Track.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error loading tracks: $e");
      return [];
    }
  }

  static Future<void> saveTracks(List<Track> tracks) async {
    try {
      final file = await _tracksFile;
      await file.writeAsString(jsonEncode(tracks.map((t) => t.toJson()).toList()));
    } catch (e) {
      debugPrint("Error saving tracks: $e");
      throw Exception("Failed to save tracks. Please retry.");
    }
  }

  // Moods
  static Future<List<Mood>> loadMoods() async {
    try {
      final file = await _moodsFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Mood.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error loading moods: $e");
      return [];
    }
  }

  static Future<void> saveMoods(List<Mood> moods) async {
    try {
      final file = await _moodsFile;
      await file.writeAsString(jsonEncode(moods.map((m) => m.toJson()).toList()));
    } catch (e) {
      debugPrint("Error saving moods: $e");
      throw Exception("Failed to save moods. Please retry.");
    }
  }
}