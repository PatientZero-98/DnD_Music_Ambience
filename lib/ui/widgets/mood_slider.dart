import 'dart:io';

import 'package:flutter/material.dart';
import '../../controllers/mood_audio_controller.dart';
import '../../controllers/mood_provider.dart';
import '../../models/track.dart';
import 'package:provider/provider.dart';

class MoodSlider extends StatefulWidget {
  final String label;
  final String? iconPath;

  const MoodSlider({super.key, required this.label, this.iconPath});

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  double _volume = 0.0;

  @override
  Widget build(BuildContext context) {
    final audioController = Provider.of<MoodAudioController>(context, listen: false);
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);

    return Expanded(
      child: DragTarget<Track>(
        onAcceptWithDetails: (details) {
          final track = details.data;
          moodProvider.addTrackToMood(widget.label, track);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Traccia assegnata a ${widget.label}!')),
          );
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                widget.iconPath != null && widget.iconPath!.isNotEmpty
                  ? CircleAvatar(
                      radius: 24,
                      backgroundImage: FileImage(File(widget.iconPath!)),
                    )
                  : const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.music_note, color: Colors.white),
                    ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.label, style: const TextStyle(fontSize: 16)),
                      Slider(
                        value: _volume,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (val) {
                          setState(() => _volume = val);
                          audioController.setMoodVolume(widget.label, val);
                        },
                      ),
                    ],
                  ),
              ),
              ],
            ),
          );
        },
      ),
    );
  }
}
