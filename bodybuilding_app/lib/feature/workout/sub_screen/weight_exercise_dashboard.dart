import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:bodybuilding_app/core/utils/training_target_input.dart';
import 'package:bodybuilding_app/feature/exercise/models/exercise.dart';
import 'package:bodybuilding_app/feature/workout/data/session_sets_service.dart';
import 'package:bodybuilding_app/feature/workout/models/workout_log.dart';
import 'package:bodybuilding_app/feature/workout/widgets/workout_table.dart';
import 'package:bodybuilding_app/feature/workout/widgets/workout_detail_history_table.dart';
import 'package:bodybuilding_app/feature/workout/widgets/technique_notes_card.dart';
import 'package:bodybuilding_app/feature/workout/widgets/progress_graph.dart';
import 'package:bodybuilding_app/feature/workout/widgets/small_stat_card.dart';

bool _strengthSetHasValues(SetEntry s) {
  final w = s.weight;
  final r = s.reps;
  if (w == null || w <= 0 || w > 999.5) return false;
  if (r == null ||
      r < TrainingTargetInput.minReps ||
      r > TrainingTargetInput.maxReps) {
    return false;
  }
  return true;
}

/// True when each set index `1..maxSets` appears on exactly one row with valid weight+reps.
///
/// Uses [SetEntry.setNumber] as the source of truth, not list order, so renumbering or
/// extra rows (e.g. set `99`) do not break detection as long as slots `1..maxSets` exist and are complete.
/// Duplicate or missing indices keep the session "in progress" until the data matches.
bool _strengthSessionLooksComplete(List<SetEntry> sets, int maxSets) {
  for (var n = 1; n <= maxSets; n++) {
    final forN = sets.where((s) => s.setNumber == n).toList();
    if (forN.length != 1) return false;
    if (!_strengthSetHasValues(forN.single)) return false;
  }
  return true;
}

/// Strength session grid: one editable row at a time (the latest set).
/// Enter weight and reps, tap **ADD SET** to lock that row and open the next;
/// on the last target set, tap **FINISH WORKOUT** to lock the table.
class WeightExerciseDashboard extends StatefulWidget {
  final Exercise exercise;

  /// Bumps [TechniqueNotesCard] key so saved notes refetch from DataStore.
  final int techniqueNotesRefreshToken;

  const WeightExerciseDashboard({
    super.key,
    required this.exercise,
    this.techniqueNotesRefreshToken = 0,
  });

  @override
  State<WeightExerciseDashboard> createState() =>
      _WeightExerciseDashboardState();
}

class _WeightExerciseDashboardState extends State<WeightExerciseDashboard> {
  late List<SetEntry> _sets;
  bool _workoutFinished = false;
  bool _sessionReady = true;
  bool _addingSet = false;
  String? _workoutLogId;
  List<double> _trainingLoadSeries = [];
  List<String> _trainingLoadLabels = [];
  List<WorkoutLog> _historySessions = [];
  final SessionSetsService _sessionSetsService = SessionSetsService();
  final GlobalKey<SessionLogTableState> _sessionTableKey =
      GlobalKey<SessionLogTableState>();

  int get _maxSets {
    final n = widget.exercise.sets;
    if (n < TrainingTargetInput.minSets) {
      return TrainingTargetInput.minSets;
    }
    if (n > TrainingTargetInput.maxSets) {
      return TrainingTargetInput.maxSets;
    }
    return n;
  }

  int? get _editableRowIndex {
    if (_workoutFinished || _sets.isEmpty) return null;
    return _sets.length - 1;
  }

  bool get _lastRowComplete =>
      _sets.isNotEmpty && _strengthSetHasValues(_sets.last);

  @override
  void initState() {
    super.initState();
    _sets = [const SetEntry(setNumber: 1)];
    final linkId = widget.exercise.routineExerciseId;
    if (linkId != null) {
      _sessionReady = false;
      _loadPersistedSession(linkId);
      _loadTrainingLoadHistory(linkId);
    }
  }

  Future<void> _loadTrainingLoadHistory(String routineExerciseId) async {
    try {
      final sessions = await _sessionSetsService.recentWorkoutsWithSets(
        routineExerciseId,
        limit: 20,
      );
      if (!mounted) return;
      final graphSlice = sessions.length > 7
          ? sessions.sublist(sessions.length - 7)
          : sessions;
      setState(() {
        _historySessions = sessions;
        _trainingLoadSeries = graphSlice
            .map((w) => totalTrainingLoadForSets(w.sets))
            .toList();
        _trainingLoadLabels = graphSlice
            .map((w) => '${w.date.month}/${w.date.day}')
            .toList();
      });
    } catch (e, st) {
      safePrint('Training load history failed: $e $st');
    }
  }

  String get _latestTrainingLoadDisplay {
    if (_trainingLoadSeries.isEmpty) return '—';
    final v = _trainingLoadSeries.last;
    if (v >= 1000) return v.round().toString();
    if (v == v.roundToDouble()) return v.round().toString();
    return v.toStringAsFixed(1);
  }

  Future<void> _loadPersistedSession(String routineExerciseId) async {
    try {
      final log = await _sessionSetsService.getOrCreateTodaysLog(
        routineExerciseId,
      );
      final loaded = await _sessionSetsService.loadSets(log.id);
      if (!mounted) return;
      setState(() {
        _workoutLogId = log.id;
        if (loaded.isNotEmpty) {
          final stillPristineFirstRow =
              _sets.length == 1 &&
              _sets.single.setNumber == 1 &&
              _sets.single.datastoreId == null &&
              _sets.single.weight == null &&
              _sets.single.reps == null;
          if (stillPristineFirstRow) {
            _sets = loaded;
          }
        }
        _workoutFinished = _strengthSessionLooksComplete(_sets, _maxSets);
        _sessionReady = true;
      });
    } catch (e, st) {
      safePrint('SessionSetsService load failed: $e $st');
      if (mounted) {
        setState(() => _sessionReady = true);
      }
    }
  }

  void _persistSetRow(int index, SetEntry entry) {
    final logId = _workoutLogId;
    if (logId == null) return;
    _sessionSetsService
        .persistSet(logId, entry)
        .then((updated) {
          if (mounted) setState(() => _sets[index] = updated);
        })
        .catchError((Object e, StackTrace st) {
          safePrint('SessionSetsService persist failed: $e $st');
        });
  }

  void _onPrimaryAction() {
    _sessionTableKey.currentState?.commitPendingEdits();
    FocusScope.of(context).unfocus();
    // Next frame so any focus-dismiss commits land before we validate / persist.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_lastRowComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter weight and reps for this set first.'),
          ),
        );
        return;
      }
      if (_sets.length < _maxSets) {
        if (_addingSet) return;
        final nextNumber = _sets.length + 1;
        final logId = _workoutLogId;
        if (logId != null) {
          setState(() => _addingSet = true);
          _persistAndAddSet(logId, nextNumber);
        } else {
          setState(() {
            _sets.add(SetEntry(setNumber: nextNumber));
          });
        }
      } else {
        _finishWorkout(logId: _workoutLogId);
      }
    });
  }

  /// Locks the grid immediately; persists the last row in the background when online.
  void _finishWorkout({String? logId}) {
    final lastIndex = _sets.length - 1;
    final lastEntry = _sets[lastIndex];
    setState(() => _workoutFinished = true);

    void refreshHistory() {
      final rid = widget.exercise.routineExerciseId;
      if (rid != null) {
        _loadTrainingLoadHistory(rid);
      }
    }

    if (logId == null) {
      refreshHistory();
      return;
    }
    _sessionSetsService
        .persistSet(logId, lastEntry)
        .then((saved) async {
          if (!mounted) return;
          final updatedSets = List<SetEntry>.from(_sets);
          updatedSets[lastIndex] = saved;
          setState(() => _sets[lastIndex] = saved);
          try {
            await _sessionSetsService.saveWorkoutLogTotalTrainingLoad(
              logId,
              updatedSets,
            );
          } catch (e, st) {
            safePrint('SessionSetsService total load save failed: $e $st');
          }
          if (mounted) refreshHistory();
        })
        .catchError((Object e, StackTrace st) {
          safePrint('SessionSetsService finish persist failed: $e $st');
          refreshHistory();
        });
  }

  Future<void> _persistAndAddSet(String logId, int nextNumber) async {
    try {
      final lastIndex = _sets.length - 1;
      final savedLast = await _sessionSetsService.persistSet(
        logId,
        _sets[lastIndex],
      );
      if (!mounted) return;
      setState(() => _sets[lastIndex] = savedLast);
      final newRow = await _sessionSetsService.persistSet(
        logId,
        SetEntry(setNumber: nextNumber),
      );
      if (!mounted) return;
      setState(() {
        _sets.add(newRow);
        _addingSet = false;
      });
    } catch (e, st) {
      safePrint('SessionSetsService add set failed: $e $st');
      if (mounted) setState(() => _addingSet = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TechniqueNotesCard(
          key: ValueKey(widget.techniqueNotesRefreshToken),
          amplifyExerciseId: widget.exercise.id,
        ),
        const SizedBox(height: 16),
        SessionLogTable(
          key: _sessionTableKey,
          sets: _sets,
          // Keep the active row editable while the log loads; values were
          // showing as "--" for the whole session when this was tied to [_sessionReady].
          editableRowIndex: _editableRowIndex,
          workoutFinished: _workoutFinished,
          maxSets: _maxSets,
          onSetCommitted: (index, entry) {
            setState(() => _sets[index] = entry);
            _persistSetRow(index, entry);
          },
          primaryButtonEnabled:
              _sessionReady && _lastRowComplete && !_addingSet,
          onPrimaryAction: !_sessionReady || _workoutFinished
              ? null
              : _onPrimaryAction,
        ),
        const SizedBox(height: 24),
        ProgressGraph(
          title: 'PROGRESS',
          subtitle: '· last 7 workouts',
          currentValue: _latestTrainingLoadDisplay,
          unit: 'kg×reps',
          series: _trainingLoadSeries,
          xLabels: _trainingLoadLabels,
        ),

        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(
              child: StatCard(
                label: '1-REP MAX',
                value: '125',
                unit: 'KG',
                sublabel: 'Current Peak',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: StatCard(
                label: 'PERCENTAGE INCREASE',
                value: '+5.2',
                unit: '%',
                sublabel: 'Since Last Month',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        WorkoutDetailHistoryTable(sessions: _historySessions),
      ],
    );
  }
}
