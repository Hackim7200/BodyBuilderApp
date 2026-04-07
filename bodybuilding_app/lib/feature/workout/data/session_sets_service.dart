import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bodybuilding_app/feature/workout/models/workout_log.dart' as session;
import 'package:bodybuilding_app/models/SetEntry.dart' as ds;
import 'package:bodybuilding_app/models/WorkoutLog.dart' as ds;

/// One saved [WorkoutLog] session’s total strength training load (Σ set loads).
class WorkoutTrainingLoadPoint {
  const WorkoutTrainingLoadPoint({
    required this.date,
    required this.totalTrainingLoad,
  });

  final DateTime date;
  final double totalTrainingLoad;
}

/// Loads and saves strength [SetEntry] rows in DataStore for the current
/// calendar day, scoped by [RoutineExercise] via [WorkoutLog.routineExerciseId].
class SessionSetsService {
  /// Local-calendar “today” match so a session reopened the same day reloads rows.
  bool _isSameLocalCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<ds.WorkoutLog?> _findTodaysLog(String routineExerciseId) async {
    final logs = await Amplify.DataStore.query(
      ds.WorkoutLog.classType,
      where: ds.WorkoutLog.ROUTINEEXERCISEID.eq(routineExerciseId),
    );
    final nowLocal = DateTime.now();
    ds.WorkoutLog? best;
    for (final log in logs) {
      final local = log.date.getDateTimeInUtc().toLocal();
      if (_isSameLocalCalendarDay(local, nowLocal)) {
        if (best == null || log.date.compareTo(best.date) > 0) {
          best = log;
        }
      }
    }
    return best;
  }

  /// Ensures a [WorkoutLog] exists for this link and local today.
  Future<ds.WorkoutLog> getOrCreateTodaysLog(String routineExerciseId) async {
    final existing = await _findTodaysLog(routineExerciseId);
    if (existing != null) return existing;
    final log = ds.WorkoutLog(
      routineExerciseId: routineExerciseId,
      date: TemporalDateTime.now(),
    );
    await Amplify.DataStore.save(log);
    return log;
  }

  Future<List<session.SetEntry>> loadSets(String workoutLogId) async {
    final rows = await Amplify.DataStore.query(
      ds.SetEntry.classType,
      where: ds.SetEntry.WORKOUTLOGID.eq(workoutLogId),
    );
    rows.sort((a, b) => a.setNumber.compareTo(b.setNumber));
    return rows.map(_fromDatastore).toList();
  }

  session.SetEntry _fromDatastore(ds.SetEntry m) {
    final load = m.trainingLoad ??
        session.trainingLoadForStrengthSet(m.weight, m.reps);
    return session.SetEntry(
      setNumber: m.setNumber,
      weight: m.weight,
      reps: m.reps,
      isCompleted: m.isCompleted ?? false,
      trainingLoad: load,
      datastoreId: m.id,
    );
  }

  /// Creates or updates one set row; returns UI model with [SetEntry.datastoreId] set.
  Future<session.SetEntry> persistSet(
    String workoutLogId,
    session.SetEntry entry,
  ) async {
    final load = session.trainingLoadForStrengthSet(entry.weight, entry.reps);
    final m = ds.SetEntry(
      id: entry.datastoreId,
      workoutLogId: workoutLogId,
      setNumber: entry.setNumber,
      weight: entry.weight,
      reps: entry.reps,
      trainingLoad: load,
      isCompleted: entry.isCompleted,
    );
    await Amplify.DataStore.save(m);
    return entry.copyWith(datastoreId: m.id, trainingLoad: load);
  }

  /// Most recent [limit] distinct [WorkoutLog]s for this routine exercise, oldest first.
  /// Each point is the sum of per-set training load (stored or derived from weight × reps).
  Future<List<WorkoutTrainingLoadPoint>> lastWorkoutsTrainingLoad(
    String routineExerciseId, {
    int limit = 7,
  }) async {
    final withSets = await recentWorkoutsWithSets(
      routineExerciseId,
      limit: limit,
    );
    return withSets
        .map(
          (w) => WorkoutTrainingLoadPoint(
            date: w.date,
            totalTrainingLoad: session.totalTrainingLoadForSets(w.sets),
          ),
        )
        .toList();
  }

  /// Recent [WorkoutLog] sessions with strength sets loaded, oldest first.
  Future<List<session.WorkoutLog>> recentWorkoutsWithSets(
    String routineExerciseId, {
    int limit = 20,
  }) async {
    final logs = await Amplify.DataStore.query(
      ds.WorkoutLog.classType,
      where: ds.WorkoutLog.ROUTINEEXERCISEID.eq(routineExerciseId),
    );
    if (logs.isEmpty) return [];

    logs.sort((a, b) => b.date.compareTo(a.date));
    final selected = logs.take(limit).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final out = <session.WorkoutLog>[];
    for (final log in selected) {
      final sets = await loadSets(log.id);
      out.add(
        session.WorkoutLog(
          id: log.id,
          exerciseId: routineExerciseId,
          date: log.date.getDateTimeInUtc().toLocal(),
          sets: sets,
        ),
      );
    }
    return out;
  }
}
