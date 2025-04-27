import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../models/track.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class FileImportService {
  static Future<Track?> importTrack() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();
      final newFile = await file.copy(
        path.join(appDir.path, result.files.single.name),
      );

      return Track(
        id: const Uuid().v4(),
        name: result.files.single.name,
        path: newFile.path,
      );
    }

    return null;
  }

  static Future<String?> copyIconToAppFolder(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final moodDir = Directory(p.join(appDir.path, 'moods'));

    if (!await moodDir.exists()) {
      await moodDir.create(recursive: true);
    }

    final fileName = p.basename(sourcePath);
    final newPath = p.join(moodDir.path, fileName);

    final newFile = await File(sourcePath).copy(newPath);

    return newFile.path;
  }

  static Future<List<Track>> importTracks() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
      allowMultiple: true, // <<< MULTIPLE
    );

    if (result == null || result.files.isEmpty) return [];

    final appDir = await getApplicationDocumentsDirectory();
    List<Track> tracks = [];

    for (var file in result.files) {

      if (file.path==null) continue;

      final sourceFile = File(file.path!);

      final newFilePath = path.join(appDir.path, file.name);
      final newFile = await sourceFile.copy(newFilePath);

      final track = Track(
        id: const Uuid().v4(),
        name: file.name,
        path: newFile.path,
      );

      tracks.add(track);
    }

    print('Importati ${tracks.length} files.');
    return tracks;
  }
}
