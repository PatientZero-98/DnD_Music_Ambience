import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../controllers/mood_provider.dart';
import '../../services/file_import_service.dart';

class MoodEditorDialog extends StatefulWidget {
  final String initialName;
  final String? initialIconPath;
  final MoodProvider moodProvider; // <<< AGGIUNTA QUI
  final void Function(String name, String? iconPath) onSave;

  const MoodEditorDialog({
    super.key,
    required this.initialName,
    required this.initialIconPath,
    required this.moodProvider,
    required this.onSave,
  });

  @override
  State<MoodEditorDialog> createState() => _MoodEditorDialogState();
}

class _MoodEditorDialogState extends State<MoodEditorDialog> {
  late TextEditingController _nameController;
  String? _selectedIconPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedIconPath = widget.initialIconPath;
  }

  Future<void> pickIcon() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      final savedPath = await FileImportService.copyIconToAppFolder(
          result.files.single.path!);

      if (savedPath != null) {
        setState(() {
          _selectedIconPath = savedPath;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifica Mood'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nome Mood
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome Mood'),
            ),
            const SizedBox(height: 20),
            // Icona Mood
            GestureDetector(
              onTap: pickIcon,
              child: _selectedIconPath != null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: _selectedIconPath != null
                      ? FileImage(File(_selectedIconPath!))
                      : null,
                      child: _selectedIconPath == null ? const Icon(Icons.add_a_photo) : null,
                    )
                  : const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.add_a_photo),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // SOLO chiudere, nessun salvataggio
          },
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text;
            final iconPath = _selectedIconPath;

            widget.onSave(name, iconPath); // Qui salvi il mood!
            Navigator.pop(context); // Chiudi il dialog
          },
          child: const Text('Salva'),
        ),
      ],
    );
  }
}
