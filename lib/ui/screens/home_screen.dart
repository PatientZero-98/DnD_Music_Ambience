import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mood_provider.dart';
import '../../models/mood.dart'; // <<<<<< AGGIUNGI QUESTO!!!
import '../widgets/track_browser_column.dart';
import '../widgets/mood_slider.dart';
import '../widgets/mood_editor_dialog.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = Provider.of<MoodProvider>(context).moods;
    final sortedMoods = List.from(moods)
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambience Music Controller'),
        // NIENTE pulsante add mood qui!
      ),
      body: Column(
        children: [
          // Track Browser sopra
          Expanded(
            flex: 1,
            child: Row(
              children: const [
                Expanded(child: TrackBrowserColumn(columnIndex: 0)),
                Expanded(child: TrackBrowserColumn(columnIndex: 1)),
                Expanded(child: TrackBrowserColumn(columnIndex: 2)),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          // Mood Mixer sotto
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Moods dinamici caricati
                  ...sortedMoods.map((mood) => Dismissible(
                        key: Key(mood.name),
                        background: Container(
                            color: Colors.redAccent,
                            child:
                                const Icon(Icons.delete, color: Colors.white)),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Conferma eliminazione'),
                              content: Text(
                                  'Vuoi eliminare il mood "${mood.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Annulla'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Elimina'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          final moodProvider =
                              Provider.of<MoodProvider>(context, listen: false);
                          moodProvider.deleteMood(mood.name);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Mood "${mood.name}" eliminato')),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: MoodSlider(
                                    label: mood.name, iconPath: mood.iconPath)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                  // Bottone + ADD MOOD alla fine
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Add Mood'),
                      onPressed: () => openMoodEditor(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openMoodEditor(BuildContext context) {
  final moodProvider = Provider.of<MoodProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => MoodEditorDialog(
      initialName: 'Nuovo Mood',
      initialIconPath: null,
      moodProvider: moodProvider, // <<< PASSIAMO QUI
      onSave: (name, iconPath) {
        moodProvider.addMood(Mood(
          name: name,
          iconPath: iconPath ?? '',
          tracks: [],
          volume: 0.0,
        ));
      },
    ),
  );
}

}
