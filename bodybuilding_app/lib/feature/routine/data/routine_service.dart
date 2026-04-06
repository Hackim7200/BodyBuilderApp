import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bodybuilding_app/models/routine.dart';
import 'package:bodybuilding_app/models/RoutineExercise.dart';
import 'package:bodybuilding_app/models/SetEntry.dart';
import 'package:bodybuilding_app/models/WorkoutLog.dart';

class RoutineService {
  Future<void> saveRoutine(Routine routine) async {
    await Amplify.DataStore.save(routine);
  }

  Stream<QuerySnapshot<Routine>> observeRoutines() {
    return Amplify.DataStore.observeQuery(Routine.classType);
  }

  /// Deletes a routine and all related data (exercises, logs, sets).
  Future<void> deleteRoutine(Routine routine) async {
    final links = await Amplify.DataStore.query(
      RoutineExercise.classType,
      where: RoutineExercise.ROUTINEID.eq(routine.id),
    );

    for (final link in links) {
      await _deleteLogsForLink(link.id);
      await Amplify.DataStore.delete(link);
    }

    await Amplify.DataStore.delete(routine);
  }

  Future<void> _deleteLogsForLink(String linkId) async {
    final logs = await Amplify.DataStore.query(
      WorkoutLog.classType,
      where: WorkoutLog.ROUTINEEXERCISEID.eq(linkId),
    );
    for (final log in logs) {
      await _deleteSetsForLog(log.id);
      await Amplify.DataStore.delete(log);
    }
  }

  Future<void> _deleteSetsForLog(String logId) async {
    final sets = await Amplify.DataStore.query(
      SetEntry.classType,
      where: SetEntry.WORKOUTLOGID.eq(logId),
    );
    for (final s in sets) {
      await Amplify.DataStore.delete(s);
    }
  }
}
