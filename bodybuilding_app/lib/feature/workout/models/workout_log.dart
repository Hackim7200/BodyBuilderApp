class _Unset {
  const _Unset();
}

/// Distinguishes “omit field” from “set to null” in [SetEntry.copyWith].
const _unset = _Unset();

class SetEntry {
  final int setNumber;
  final double? weight;
  final int? reps;
  final bool isCompleted;
  /// DataStore primary key for [SetEntry] when persisted; null for new rows.
  final String? datastoreId;

  const SetEntry({
    required this.setNumber,
    this.weight,
    this.reps,
    this.isCompleted = false,
    this.datastoreId,
  });

  SetEntry copyWith({
    int? setNumber,
    Object? weight = _unset,
    Object? reps = _unset,
    bool? isCompleted,
    Object? datastoreId = _unset,
  }) {
    return SetEntry(
      setNumber: setNumber ?? this.setNumber,
      weight: identical(weight, _unset) ? this.weight : weight as double?,
      reps: identical(reps, _unset) ? this.reps : reps as int?,
      isCompleted: isCompleted ?? this.isCompleted,
      datastoreId: identical(datastoreId, _unset)
          ? this.datastoreId
          : datastoreId as String?,
    );
  }
}

class TimerEntry {
  final Duration duration;
  final DateTime date;

  const TimerEntry({
    required this.duration,
    required this.date,
  });

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class WorkoutLog {
  final String id;
  final String exerciseId;
  final DateTime date;
  final List<SetEntry> sets;
  final List<TimerEntry> timerEntries;
  final double? estimatedOneRepMax;

  const WorkoutLog({
    required this.id,
    required this.exerciseId,
    required this.date,
    this.sets = const [],
    this.timerEntries = const [],
    this.estimatedOneRepMax,
  });

  static List<WorkoutLog> get dummyBenchLogs => [
        WorkoutLog(
          id: 'wl1',
          exerciseId: 'e1',
          date: DateTime(2023, 10, 24),
          sets: const [
            SetEntry(setNumber: 1, weight: 100, reps: 8, isCompleted: true),
            SetEntry(setNumber: 2, weight: 100, reps: 8, isCompleted: false),
            SetEntry(setNumber: 3),
            SetEntry(setNumber: 4),
          ],
          estimatedOneRepMax: 112.5,
        ),
      ];

  static List<WorkoutLog> get dummyDipsLogs => [
        WorkoutLog(
          id: 'wl2',
          exerciseId: 'e2',
          date: DateTime(2023, 10, 24),
          sets: const [
            SetEntry(setNumber: 1, weight: 20, reps: 12, isCompleted: true),
            SetEntry(setNumber: 2, weight: 20, reps: 10, isCompleted: true),
            SetEntry(setNumber: 3, weight: 20, reps: 9, isCompleted: true),
          ],
          estimatedOneRepMax: 28.0,
        ),
      ];

  static List<WorkoutLog> get dummyShoulderLogs => [
        WorkoutLog(
          id: 'wl3',
          exerciseId: 'e3',
          date: DateTime(2023, 10, 24),
          sets: const [
            SetEntry(setNumber: 1, weight: 60, reps: 6, isCompleted: true),
            SetEntry(setNumber: 2, weight: 60, reps: 5, isCompleted: true),
          ],
          estimatedOneRepMax: 70.0,
        ),
      ];

  static List<WorkoutLog> get dummyTimerLogs => [
        WorkoutLog(
          id: 'wl4',
          exerciseId: 'e6',
          date: DateTime(2023, 10, 24),
          timerEntries: [
            TimerEntry(
              duration: const Duration(minutes: 1, seconds: 42),
              date: DateTime(2023, 10, 24),
            ),
            TimerEntry(
              duration: const Duration(minutes: 2, seconds: 0),
              date: DateTime(2023, 10, 22),
            ),
            TimerEntry(
              duration: const Duration(minutes: 1, seconds: 55),
              date: DateTime(2023, 10, 20),
            ),
          ],
        ),
      ];

  static List<double> get dummyProgressionData => [80, 75, 85, 60, 45, 30];
  static List<String> get dummyProgressionLabels =>
      ['WK 01', 'WK 02', 'WK 03', 'WK 04', 'WK 05', 'CURRENT'];
}
