import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bodybuilding_app/core/widgets/kinetic_app_bar.dart';
import 'package:bodybuilding_app/feature/exercise/models/exercise.dart';
import 'package:bodybuilding_app/feature/exercise/models/exercise_ui_mapper.dart';
import 'package:bodybuilding_app/feature/workout/sub_screen/weight_exercise_dashboard.dart';
import 'package:bodybuilding_app/feature/workout/sub_screen/timer_exercise_dashboard.dart';
import 'package:bodybuilding_app/feature/routine/screens/edit_exercise_screen.dart';
import 'package:bodybuilding_app/feature/workout/widgets/technique_notes_editor.dart';
import 'package:bodybuilding_app/models/Exercise.dart' as amp;
import 'package:bodybuilding_app/models/RoutineExercise.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  /// Routine link when opened from a routine (enables edit/delete on workout page).
  final RoutineExercise? routineLink;
  final amp.Exercise? amplifyExercise;
  final String? routineName;

  /// Passed through [exerciseForWorkoutDetail] when refreshing after edit.
  final int listIndex;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    this.routineLink,
    this.amplifyExercise,
    this.routineName,
    this.listIndex = 0,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late Exercise _exercise;
  int _techniqueNotesRefreshToken = 0;

  bool get _canEditFromRoutine =>
      widget.routineLink != null && widget.amplifyExercise != null;

  @override
  void initState() {
    super.initState();
    _exercise = widget.exercise;
  }

  Future<void> _onTechniqueNotesPressed() async {
    final ok = await showTechniqueNotesEditor(context, _exercise.id);
    if (ok && mounted) {
      setState(() => _techniqueNotesRefreshToken++);
    }
  }

  Future<void> _refreshExerciseFromStore() async {
    final linkId = widget.routineLink?.id;
    final exId = widget.amplifyExercise?.id;
    if (linkId == null || exId == null) return;

    try {
      final linkRows = await Amplify.DataStore.query(
        RoutineExercise.classType,
        where: RoutineExercise.ID.eq(linkId),
      );
      final exRows = await Amplify.DataStore.query(
        amp.Exercise.classType,
        where: amp.Exercise.ID.eq(exId),
      );
      if (!mounted || linkRows.isEmpty || exRows.isEmpty) return;
      setState(() {
        _exercise = exerciseForWorkoutDetail(
          exRows.first,
          linkRows.first,
          widget.listIndex,
        );
      });
    } catch (_) {
      // Keep current session UI if refresh fails.
    }
  }

  Future<void> _openEditExercise() async {
    if (!_canEditFromRoutine) return;
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => EditExerciseScreen(
          link: widget.routineLink!,
          exercise: widget.amplifyExercise!,
          routineName: widget.routineName,
        ),
      ),
    );
    if (!mounted) return;
    if (result == 'deleted') {
      Navigator.of(context).pop();
      return;
    }
    if (result == 'saved') {
      await _refreshExerciseFromStore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _exercise;
    final cs = Theme.of(context).colorScheme;

    final actions = <Widget>[];
    if (_canEditFromRoutine) {
      actions.add(
        IconButton(
          tooltip: 'Edit exercise',
          onPressed: _openEditExercise,
          icon: Icon(Icons.edit_outlined, color: cs.onSurface),
        ),
      );
    }
    if (exercise.isStrength) {
      actions.add(
        IconButton(
          tooltip: 'Technique notes',
          onPressed: _onTechniqueNotesPressed,
          icon: Icon(Icons.edit_note, color: cs.onSurface),
        ),
      );
    }

    return Scaffold(
      appBar: KineticAppBar(
        title: exercise.isTimer ? 'KINETIC ARCHIVE' : 'KINETIC',
        showBackButton: true,
        actions: actions.isEmpty ? null : actions,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Text(
                  exercise.isTimer ? 'CURRENT EXERCISE' : 'CURRENT SESSION',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: cs.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exercise.name.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: exercise.isTimer ? 28 : 40,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                    height: 1.0,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Dynamic content based on exercise type
          if (exercise.isStrength)
            WeightExerciseDashboard(
              exercise: exercise,
              techniqueNotesRefreshToken: _techniqueNotesRefreshToken,
            )
          else
            TimerExerciseDashboard(exercise: exercise),
        ],
      ),
    );
  }
}
