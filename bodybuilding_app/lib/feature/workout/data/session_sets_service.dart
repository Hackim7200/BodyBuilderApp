import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bodybuilding_app/feature/workout/models/workout_log.dart'
    as session;
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
    final load =
        m.trainingLoad ?? session.trainingLoadForStrengthSet(m.weight, m.reps);
    return session.SetEntry(
      setNumber: m.setNumber,
      weight: m.weight,
      reps: m.reps,
      isCompleted: m.isCompleted ?? false,
      trainingLoad: load,
      durationSeconds: m.durationSeconds,
      datastoreId: m.id,
    );
  }

  /// Sum of training load for a saved log: prefer stored [WorkoutLog.totalTrainingLoad], else Σ sets.
  Future<double> _resolvedTotalTrainingLoadForLog(ds.WorkoutLog log) async {
    final stored = log.totalTrainingLoad;
    if (stored != null) return stored;
    final sets = await loadSets(log.id);
    return session.aggregateMetricForWorkoutLogSets(sets);
  }

  /// Percent change vs chronologically previous session: `((current − previous) / previous) × 100`.
  static double? trainingLoadChangePercentVsPrevious(
    double currentTotal,
    double? previousTotal,
  ) {
    if (previousTotal == null || previousTotal <= 0) return null;
    return ((currentTotal - previousTotal) / previousTotal) * 100.0;
  }

  /// Strength volume change for the most recent session that has data, vs the
  /// session before it. Uses persisted [WorkoutLog.trainingLoadChangePercent]
  /// when set; otherwise derives from consecutive [WorkoutLog.totalTrainingLoad]
  /// values. Skips a newest log with no totals (e.g. in-progress day).
  static double? trainingLoadChangePercentForLatestSession(
    String routineExerciseId,
    List<ds.WorkoutLog> allLogs,
  ) {
    final ordered = allLogs
        .where((l) => l.routineExerciseId == routineExerciseId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    for (var i = 0; i < ordered.length; i++) {
      final log = ordered[i];
      final saved = log.trainingLoadChangePercent;
      if (saved != null) return saved;

      if (i + 1 < ordered.length) {
        final cur = log.totalTrainingLoad;
        final prev = ordered[i + 1].totalTrainingLoad;
        if (cur != null && prev != null && prev > 0) {
          return trainingLoadChangePercentVsPrevious(cur, prev);
        }
      }
    }
    return null;
  }

  /// Writes Σ per-set training load and % change vs the previous [WorkoutLog] for this routine exercise.
  Future<void> saveWorkoutLogTotalTrainingLoad(
    String workoutLogId,
    List<session.SetEntry> sets,
  ) async {
    final total = session.aggregateMetricForWorkoutLogSets(sets);
    final rows = await Amplify.DataStore.query(
      ds.WorkoutLog.classType,
      where: ds.WorkoutLog.ID.eq(workoutLogId),
    );
    if (rows.isEmpty) return;
    final current = rows.first;

    final siblings = await Amplify.DataStore.query(
      ds.WorkoutLog.classType,
      where: ds.WorkoutLog.ROUTINEEXERCISEID.eq(current.routineExerciseId),
    );
    siblings.sort((a, b) => a.date.compareTo(b.date));
    final idx = siblings.indexWhere((l) => l.id == workoutLogId);

    double? changePercent;
    if (idx > 0) {
      final previousTotal =
          await _resolvedTotalTrainingLoadForLog(siblings[idx - 1]);
      changePercent = trainingLoadChangePercentVsPrevious(total, previousTotal);
    }

    final updated = changePercent != null
        ? current.copyWith(
            totalTrainingLoad: total,
            trainingLoadChangePercent: changePercent,
          )
        : current.copyWith(totalTrainingLoad: total);
    await Amplify.DataStore.save(updated);
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
      durationSeconds: entry.durationSeconds,
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
          totalTrainingLoad: log.totalTrainingLoad,
          trainingLoadChangePercent: log.trainingLoadChangePercent,
        ),
      );
    }
    return out;
  }

  /// Heaviest valid strength set (weight with reps in app ranges) across all
  /// logs for this exercise whose session date falls within the last [days]
  /// (rolling, local time).
  Future<double?> maxStrengthWeightLastDays(
    String routineExerciseId, {
    int days = 30,
  }) async {
    final logs = await Amplify.DataStore.query(
      ds.WorkoutLog.classType,
      where: ds.WorkoutLog.ROUTINEEXERCISEID.eq(routineExerciseId),
    );
    if (logs.isEmpty) return null;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    double? best;
    for (final log in logs) {
      final local = log.date.getDateTimeInUtc().toLocal();
      if (local.isBefore(cutoff)) continue;
      final sets = await loadSets(log.id);
      for (final s in sets) {
        if (session.trainingLoadForStrengthSet(s.weight, s.reps) == null) {
          continue;
        }
        final w = s.weight!;
        if (best == null || w > best) best = w;
      }
    }
    return best;
  }

  /// Longest single timed hold ([SetEntry.durationSeconds]) across all logs
  /// for this exercise whose session date falls within the last [days]
  /// (rolling, local time).
  Future<int?> maxTimerHoldSecondsLastDays(
    String routineExerciseId, {
    int days = 30,
  }) async {
    final logs = await Amplify.DataStore.query(
      ds.WorkoutLog.classType,
      where: ds.WorkoutLog.ROUTINEEXERCISEID.eq(routineExerciseId),
    );
    if (logs.isEmpty) return null;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    int? best;
    for (final log in logs) {
      final local = log.date.getDateTimeInUtc().toLocal();
      if (local.isBefore(cutoff)) continue;
      final sets = await loadSets(log.id);
      for (final s in sets) {
        final d = s.durationSeconds;
        if (d == null || d < 1) continue;
        if (best == null || d > best) best = d;
      }
    }
    return best;
  }
}
