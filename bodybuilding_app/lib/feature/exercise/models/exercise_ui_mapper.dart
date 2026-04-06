import 'package:bodybuilding_app/feature/exercise/models/exercise.dart';
import 'package:bodybuilding_app/models/Exercise.dart' as amplify;
import 'package:bodybuilding_app/models/RoutineExercise.dart';

int _defaultSetsForIndex(int listIndex) {
  switch (listIndex % 3) {
    case 0:
      return 4;
    case 1:
      return 3;
    default:
      return 3;
  }
}

int _defaultRepsForIndex(int listIndex) {
  switch (listIndex % 3) {
    case 0:
      return 8;
    case 1:
      return 12;
    default:
      return 6;
  }
}

/// Parses reps from stored text (e.g. "10", "8-12") so detail views get a number.
int? _parseRepsFromTarget(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return null;
  final direct = int.tryParse(t);
  if (direct != null) return direct;
  final m = RegExp(r'\d+').firstMatch(t);
  if (m == null) return null;
  return int.tryParse(m.group(0)!);
}

/// Maps Amplify exercise + routine link into the feature [Exercise] used by
/// [ExerciseDetailScreen] (sets/reps/rest/timer type from real row data).
Exercise exerciseForWorkoutDetail(
  amplify.Exercise? amplifyExercise,
  RoutineExercise link,
  int listIndex,
) {
  final isTimer = amplifyExercise?.type == 'timer';
  final name = amplifyExercise?.name ?? 'Unknown exercise';

  final sets = link.targetSets ?? _defaultSetsForIndex(listIndex);
  int reps = 0;
  if (!isTimer) {
    final parsed = link.targetReps != null
        ? _parseRepsFromTarget(link.targetReps!)
        : null;
    reps = parsed ?? _defaultRepsForIndex(listIndex);
  }

  final restTime = link.restSeconds != null
      ? Duration(seconds: link.restSeconds!)
      : null;

  return Exercise(
    id: amplifyExercise?.id ?? link.exerciseId,
    name: name,
    type: isTimer ? ExerciseType.timer : ExerciseType.strength,
    sets: sets,
    reps: reps,
    restTime: restTime,
    routineExerciseId: link.id,
  );
}
