import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bodybuilding_app/models/Exercise.dart';

/// Reads and updates [Exercise.techniques] in DataStore (per-exercise technique notes).
class ExerciseTechniquesService {
  Future<String?> storedTechniquesTrimmed(String exerciseId) async {
    final rows = await Amplify.DataStore.query(
      Exercise.classType,
      where: Exercise.ID.eq(exerciseId),
    );
    if (rows.isEmpty) return null;
    final t = rows.first.techniques?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }

  /// Raw text for the editor (may be empty; not null).
  Future<String> techniquesForEditor(String exerciseId) async {
    final rows = await Amplify.DataStore.query(
      Exercise.classType,
      where: Exercise.ID.eq(exerciseId),
    );
    if (rows.isEmpty) return '';
    return rows.first.techniques?.trim() ?? '';
  }

  Future<void> saveTechniques({
    required String exerciseId,
    required String text,
  }) async {
    final rows = await Amplify.DataStore.query(
      Exercise.classType,
      where: Exercise.ID.eq(exerciseId),
    );
    if (rows.isEmpty) {
      throw StateError('Exercise not found: $exerciseId');
    }
    final ex = rows.first;
    final trimmed = text.trim();
    await Amplify.DataStore.save(
      ex.copyWith(techniques: trimmed.isEmpty ? '' : trimmed),
    );
  }
}
