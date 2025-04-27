import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/mood_provider.dart';
import 'controllers/track_provider.dart'; // Make sure this exists
import 'ui/screens/home_screen.dart';

class DnDAmbienceApp extends StatelessWidget {
  const DnDAmbienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoodProvider()),
        ChangeNotifierProvider(
            create: (_) => TrackProvider()), // Add TrackProvider
      ],
      child: MaterialApp(
        title: 'DnD Ambience Controller',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const HomeScreen(),
      ),
    );
  }
}
