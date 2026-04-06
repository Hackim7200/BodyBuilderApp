import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bodybuilding_app/feature/workout/data/exercise_techniques_service.dart';

Future<String> _initialNotesText(String exerciseId) async {
  return ExerciseTechniquesService().techniquesForEditor(exerciseId);
}

/// Owns [TextEditingController] so it is disposed only after the route is torn down.
class _TechniqueNotesEditorDialog extends StatefulWidget {
  final String initialText;

  const _TechniqueNotesEditorDialog({required this.initialText});

  @override
  State<_TechniqueNotesEditorDialog> createState() =>
      _TechniqueNotesEditorDialogState();
}

class _TechniqueNotesEditorDialogState extends State<_TechniqueNotesEditorDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(
        'Technique notes',
        style: GoogleFonts.inter(fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: TextField(
          controller: _controller,
          autofocus: true,
          minLines: 4,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: 'Cueing, tempo, pain to avoid…',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            alignLabelWithHint: true,
          ),
          style: GoogleFonts.inter(fontSize: 15, height: 1.4),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop<String?>(null),
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop<String?>(_controller.text),
          child: const Text('SAVE'),
        ),
      ],
      backgroundColor: cs.surface,
    );
  }
}

/// Opens a dialog to add or edit [Exercise.techniques]; returns whether DataStore was updated.
Future<bool> showTechniqueNotesEditor(
  BuildContext context,
  String amplifyExerciseId,
) async {
  final initial = await _initialNotesText(amplifyExerciseId);

  if (!context.mounted) return false;

  final textToSave = await showDialog<String?>(
    context: context,
    builder: (ctx) => _TechniqueNotesEditorDialog(initialText: initial),
  );

  if (!context.mounted) return false;
  if (textToSave == null) return false;

  try {
    await ExerciseTechniquesService().saveTechniques(
      exerciseId: amplifyExerciseId,
      text: textToSave,
    );
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save notes. Try again.')),
      );
    }
    return false;
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Technique notes saved.')),
    );
  }
  return true;
}
