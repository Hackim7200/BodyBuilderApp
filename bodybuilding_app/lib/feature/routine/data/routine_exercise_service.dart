import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bodybuilding_app/models/Exercise.dart';
import 'package:bodybuilding_app/models/ModelProvider.dart' show ModelFieldValue;
import 'package:bodybuilding_app/models/RoutineExercise.dart';
import 'package:bodybuilding_app/models/SetEntry.dart';
import 'package:bodybuilding_app/models/WorkoutLog.dart';

class RoutineExerciseService {
  /// All links, for aggregating exercise counts per routine on the dashboard.
  Stream<QuerySnapshot<RoutineExercise>> observeAllRoutineExerciseLinks() {
    return Amplify.DataStore.observeQuery(RoutineExercise.classType);
  }

  /// All logs, for “last performed” per routine on the dashboard.
  Stream<QuerySnapshot<WorkoutLog>> observeAllWorkoutLogs() {
    return Amplify.DataStore.observeQuery(WorkoutLog.classType);
  }

  /// Latest [WorkoutLog.date] per [Routine.id], across all exercises in that routine.
  static Map<String, DateTime> lastPerformedByRoutineId({
    required List<RoutineExercise> links,
    required List<WorkoutLog> logs,
  }) {
    if (links.isEmpty || logs.isEmpty) return {};
    final linkIdToRoutineId = {for (final l in links) l.id: l.routineId};
    final best = <String, DateTime>{};
    for (final log in logs) {
      final routineId = linkIdToRoutineId[log.routineExerciseId];
      if (routineId == null) continue;
      final at = log.date.getDateTimeInUtc();
      best.update(
        routineId,
        (prev) => at.isAfter(prev) ? at : prev,
        ifAbsent: () => at,
      );
    }
    return best;
  }

  static Map<String, int> exerciseCountsByRoutineId(
    List<RoutineExercise> links,
  ) {
    final map = <String, int>{};
    for (final link in links) {
      map.update(link.routineId, (c) => c + 1, ifAbsent: () => 1);
    }
    return map;
  }

  Stream<QuerySnapshot<RoutineExercise>> observeForRoutine(String routineId) {
    return Amplify.DataStore.observeQuery(
      RoutineExercise.classType,
      where: RoutineExercise.ROUTINEID.eq(routineId),
      sortBy: [RoutineExercise.ORDERINDEX.ascending()],
    );
  }

  Future<List<RoutineExercise>> linksForRoutine(String routineId) async {
    return Amplify.DataStore.query(
      RoutineExercise.classType,
      where: RoutineExercise.ROUTINEID.eq(routineId),
      sortBy: [RoutineExercise.ORDERINDEX.ascending()],
    );
  }

  Future<Map<String, Exercise>> exerciseMapForIds(Set<String> ids) async {
    if (ids.isEmpty) return {};
    final all = await Amplify.DataStore.query(Exercise.classType);
    return {for (final e in all) if (ids.contains(e.id)) e.id: e};
  }

  Future<void> addExerciseToRoutine({
    required String routineId,
    required String name,
    required String type,
    String? muscleGroup,
    int? targetSets,
    String? targetReps,
    int? restSeconds,
  }) async {
    final links = await linksForRoutine(routineId);
    final nextOrder = links.isEmpty ? 0 : links.last.orderIndex + 1;

    final exercise = Exercise(
      name: name.trim(),
      type: type,
      muscleGroup: muscleGroup?.trim().isNotEmpty == true
          ? muscleGroup!.trim()
          : null,
    );
    await Amplify.DataStore.save(exercise);

    final link = RoutineExercise(
      routineId: routineId,
      exerciseId: exercise.id,
      orderIndex: nextOrder,
      targetSets: targetSets,
      targetReps: targetReps,
      restSeconds: restSeconds,
    );
    await Amplify.DataStore.save(link);
  }

  Future<void> removeLink(RoutineExercise link) async {
    await Amplify.DataStore.delete(link);
  }

  /// Persists name/type on [Exercise] and targets on [RoutineExercise].
  Future<void> updateExerciseInRoutine({
    required Exercise exercise,
    required RoutineExercise link,
    required String name,
    required String type,
    int? targetSets,
    String? targetReps,
  }) async {
    final updatedExercise = exercise.copyWithModelFieldValues(
      name: ModelFieldValue.value(name.trim()),
      type: ModelFieldValue.value(type),
    );
    await Amplify.DataStore.save(updatedExercise);

    final repsForStore = type == 'strength' &&
            targetReps != null &&
            targetReps.trim().isNotEmpty
        ? targetReps.trim()
        : null;

    final updatedLink = link.copyWithModelFieldValues(
      targetSets: ModelFieldValue.value(targetSets),
      targetReps: ModelFieldValue.value(repsForStore),
    );
    await Amplify.DataStore.save(updatedLink);
  }

  /// Removes the routine link, associated session logs/sets, and the exercise row.
  Future<void> deleteExerciseEntry({
    required RoutineExercise link,
    required Exercise exercise,
  }) async {
    final logs = await Amplify.DataStore.query(
      WorkoutLog.classType,
      where: WorkoutLog.ROUTINEEXERCISEID.eq(link.id),
    );
    for (final log in logs) {
      final sets = await Amplify.DataStore.query(
        SetEntry.classType,
        where: SetEntry.WORKOUTLOGID.eq(log.id),
      );
      for (final s in sets) {
        await Amplify.DataStore.delete(s);
      }
      await Amplify.DataStore.delete(log);
    }
    await Amplify.DataStore.delete(link);
    await Amplify.DataStore.delete(exercise);
  }
}
