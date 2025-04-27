import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/track_provider.dart';
import '../../services/file_import_service.dart';
import '../../models/track.dart';

class TrackBrowserColumn extends StatelessWidget {
  final int columnIndex;

  const TrackBrowserColumn({super.key, required this.columnIndex});

  @override
  Widget build(BuildContext context) {
    final trackProvider = Provider.of<TrackProvider>(context);
    final tracks = trackProvider.tracks;

    // Dividi le tracce in base al numero di colonne
    List<Track> columnTracks = [];
    for (int i = columnIndex; i < tracks.length; i += 3) {
      columnTracks.add(tracks[i]);
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text(
            'Track Browser',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Divider(),
          Expanded(
              child: tracks.isEmpty
                  ? Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Track'),
                        onPressed: () => _addTrack(context, trackProvider),
                      ),
                    )
                  : ListView(
                      children: [
                        if (columnIndex == 0)
                          ListTile(
                            leading: const Icon(Icons.add),
                            title: const Text('+ Add Track'),
                            onTap: () => _addTrack(context, trackProvider),
                          ),
                        ...columnTracks.map(
                              (track) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: Draggable<Track>(
                                data: track,
                                feedback: Material(
                                  child: Container(
                                    color: Colors.grey,
                                    padding: const EdgeInsets.all(8),
                                    child: Text(track.name,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.5,
                                  child: ListTile(
                                    leading: const Icon(Icons.music_note),
                                    title: Text(track.name),
                                  ),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.music_note),
                                  title: Text(track.name),
                                ),
                              ),
                            )
                        ).toList(),
                      ],
                    )),
        ],
      ),
    );
  }

  Future<void> _addTrack(
      BuildContext context, TrackProvider trackProvider) async {
    final newTracks = await FileImportService.importTracks();

    if (newTracks.isNotEmpty) {
      trackProvider.addTracks(newTracks);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${newTracks.length} tracce aggiunte!')), // Messaggio più generico
      );
    }
  }
}
