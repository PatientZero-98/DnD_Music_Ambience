// file: lib/ui/screens/home_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/track_provider.dart';
import '../../controllers/mood_provider.dart';
import '../../controllers/mood_audio_controller.dart';
import 'home_screen.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrackProvider()..loadTracks()),
        ChangeNotifierProvider(create: (_) => MoodProvider()..loadMoods()),
        Provider(create: (_) => MoodAudioController()),
      ],
      child: const HomeScreen(),
    );
  }
}
