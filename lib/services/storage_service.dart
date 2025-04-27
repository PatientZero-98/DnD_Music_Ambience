import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood.dart';
import '../models/track.dart';

class StorageService {
  static Future<void> saveMoods(List<Mood> moods) async {
    final prefs = await SharedPreferences.getInstance();
    final json = moods.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('moods', json);
  }

  static Future<List<Mood>> loadMoods() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('moods') ?? [];
    return jsonList.map((j) => Mood.fromJson(jsonDecode(j))).toList();
  }

  static Future<void> saveTracks(List<Track> tracks) async {
    final prefs = await SharedPreferences.getInstance();
    final json = tracks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList('tracks', json);
  }

  static Future<List<Track>> loadTracks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('tracks') ?? [];
    return jsonList.map((j) => Track.fromJson(jsonDecode(j))).toList();
  }
}
