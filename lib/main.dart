import 'package:dnd_ambience_controller/controllers/mood_audio_controller.dart';
import 'package:dnd_ambience_controller/controllers/mood_provider.dart';
import 'package:dnd_ambience_controller/controllers/track_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrackProvider()..loadTracks()),
        ChangeNotifierProvider(create: (_) => MoodProvider()..loadMoods()),
        Provider(create: (_) => MoodAudioController()), // <-- ATTENZIONE qui deve esserci!
      ],
      child: const DnDAmbienceApp(),
    ),
  );
}
