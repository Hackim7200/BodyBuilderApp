import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:bodybuilding_app/core/utils/training_target_input.dart';
import 'package:bodybuilding_app/feature/exercise/models/exercise.dart';
import 'package:bodybuilding_app/feature/workout/data/session_sets_service.dart';
import 'package:bodybuilding_app/feature/workout/models/workout_log.dart';
import 'package:bodybuilding_app/feature/workout/widgets/session_log_table.dart';
import 'package:bodybuilding_app/feature/workout/widgets/technique_notes_card.dart';
import 'package:bodybuilding_app/feature/workout/widgets/performance_archive.dart';
import 'package:bodybuilding_app/feature/workout/widgets/stat_card.dart';
import 'package:bodybuilding_app/app/themes/app_theme.dart';

class StrengthExerciseView extends StatefulWidget {
  final Exercise exercise;
  /// Bumps [TechniqueNotesCard] key so saved notes refetch from DataStore.
  final int techniqueNotesRefreshToken;

  const StrengthExerciseView({
    super.key,
    required this.exercise,
    this.techniqueNotesRefreshToken = 0,
  });

  @override
  State<StrengthExerciseView> createState() => _StrengthExerciseViewState();
}

class _StrengthExerciseViewState extends State<StrengthExerciseView> {
  late List<SetEntry> _sets;
  bool _workoutFinished = false;
  bool _sessionReady = true;
  bool _addingSet = false;
  String? _workoutLogId;
  final SessionSetsService _sessionSetsService = SessionSetsService();

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

  bool get _lastRowComplete {
    final last = _sets.last;
    final w = last.weight;
    final r = last.reps;
    if (w == null || w <= 0 || w > 999.5) return false;
    if (r == null ||
        r < TrainingTargetInput.minReps ||
        r > TrainingTargetInput.maxReps) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _sets = [const SetEntry(setNumber: 1)];
    final linkId = widget.exercise.routineExerciseId;
    if (linkId != null) {
      _sessionReady = false;
      _loadPersistedSession(linkId);
    }
  }

  Future<void> _loadPersistedSession(String routineExerciseId) async {
    try {
      final log = await _sessionSetsService.getOrCreateTodaysLog(routineExerciseId);
      final loaded = await _sessionSetsService.loadSets(log.id);
      if (!mounted) return;
      setState(() {
        _workoutLogId = log.id;
        if (loaded.isNotEmpty) {
          _sets = loaded;
        }
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
    _sessionSetsService.persistSet(logId, entry).then((updated) {
      if (mounted) setState(() => _sets[index] = updated);
    }).catchError((Object e, StackTrace st) {
      safePrint('SessionSetsService persist failed: $e $st');
    });
  }

  void _onPrimaryAction() {
    FocusScope.of(context).unfocus();
    // Next frame so focus-dismiss commits from the active row are applied to list state.
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
          _sessionSetsService
              .persistSet(
                logId,
                SetEntry(setNumber: nextNumber),
              )
              .then((row) {
                if (mounted) {
                  setState(() {
                    _sets.add(row);
                    _addingSet = false;
                  });
                }
              })
              .catchError((Object e, StackTrace st) {
                safePrint('SessionSetsService add set failed: $e $st');
                if (mounted) setState(() => _addingSet = false);
              });
        } else {
          setState(() {
            _sets.add(SetEntry(setNumber: nextNumber));
          });
        }
      } else {
        setState(() => _workoutFinished = true);
      }
    });
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
          sets: _sets,
          editableRowIndex: _sessionReady ? _editableRowIndex : null,
          workoutFinished: _workoutFinished,
          maxSets: _maxSets,
          onSetCommitted: (index, entry) {
            setState(() => _sets[index] = entry);
            _persistSetRow(index, entry);
          },
          primaryButtonEnabled:
              _sessionReady && _lastRowComplete && !_addingSet,
          onPrimaryAction:
              !_sessionReady || _workoutFinished ? null : _onPrimaryAction,
        ),
        const SizedBox(height: 24),
        const PerformanceArchive(
          title: 'Performance Archive',
          subtitle: 'Est. 1RM Progression',
          currentValue: '112.5',
          unit: 'KG',
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(
              child: StatCard(
                label: '1-REP MAX',
                value: '125',
                unit: 'KG',
                sublabel: 'Estimated Peak',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: StatCard(
                label: 'PERCENTAGE INCREASE',
                value: '+5.2%',
                sublabel: 'Since Last Month',
                icon: Icons.trending_up,
                iconColor: AppTheme.success,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
