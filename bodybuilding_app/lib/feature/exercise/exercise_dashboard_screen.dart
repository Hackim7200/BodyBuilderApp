import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bodybuilding_app/core/widgets/kinetic_app_bar.dart';
import 'package:bodybuilding_app/feature/routine/data/routine_exercise_service.dart';
import 'package:bodybuilding_app/feature/routine/routine_last_session_format.dart';
import 'package:bodybuilding_app/feature/exercise/models/exercise_ui_mapper.dart';
import 'package:bodybuilding_app/feature/routine/screens/add_exercise_screen.dart';
import 'package:bodybuilding_app/feature/routine/screens/edit_routine_screen.dart';
import 'package:bodybuilding_app/feature/workout/data/session_sets_service.dart';
import 'package:bodybuilding_app/feature/workout/workout_screen_wrapper.dart';
import 'package:bodybuilding_app/models/Exercise.dart';
import 'package:bodybuilding_app/models/RoutineExercise.dart';
import 'package:bodybuilding_app/models/WorkoutLog.dart';
import 'package:bodybuilding_app/models/routine.dart';

class _ExerciseProgressStyle {
  final Color dotColor;
  final Color valueColor;
  final String valueLabel;
  final String caption;
  final Color captionColor;

  const _ExerciseProgressStyle({
    required this.dotColor,
    required this.valueColor,
    required this.valueLabel,
    required this.caption,
    required this.captionColor,
  });
}

/// Change vs last session: negative = decrease (gray), zero = stable (amber), positive = increase (green).
_ExerciseProgressStyle _progressFromDeltaPercent(
  double deltaPercent,
  Color outlineColor,
) {
  const green = Color(0xFF2E7D32);
  const amber = Color(0xFFF59E0B);
  const gray = Color(0xFF6B7280);

  String magnitudeStr(double x) {
    final a = x.abs();
    if ((a - a.round()).abs() < 1e-9) return a.round().toString();
    return a.toStringAsFixed(1);
  }

  if (deltaPercent < 0) {
    return _ExerciseProgressStyle(
      dotColor: gray,
      valueColor: gray,
      valueLabel: '-${magnitudeStr(deltaPercent)}%',
      caption: 'VS LAST SESSION',
      captionColor: gray,
    );
  }

  if (deltaPercent == 0) {
    return _ExerciseProgressStyle(
      dotColor: amber,
      valueColor: amber,
      valueLabel: 'Stable',
      caption: 'VS LAST SESSION',
      captionColor: outlineColor,
    );
  }

  return _ExerciseProgressStyle(
    dotColor: green,
    valueColor: green,
    valueLabel: '+${magnitudeStr(deltaPercent)}%',
    caption: 'VS LAST SESSION',
    captionColor: outlineColor,
  );
}

String _subtitleLine(
  RoutineExercise link,
  int designIndex,
  Exercise? exercise,
) {
  final sets = link.targetSets;
  final reps = link.targetReps?.trim();
  final isTimer = exercise?.type == 'timer';

  if (isTimer) {
    if (sets != null) {
      return '$sets Sets | Timer';
    }
    return '— Sets | Timer';
  }

  if (sets != null && reps != null && reps.isNotEmpty) {
    return '$sets Sets | $reps Reps';
  }
  if (sets != null) {
    return '$sets Sets | —';
  }
  switch (designIndex % 3) {
    case 0:
      return '4 Sets | 8 Reps';
    case 1:
      return '3 Sets | 12 Reps';
    default:
      return '3 Sets | 6 Reps';
  }
}

class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;

  const RoutineDetailScreen({super.key, required this.routine});

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  late Routine _routine;
  final _linkService = RoutineExerciseService();

  @override
  void initState() {
    super.initState();
    _routine = widget.routine;
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Routine>(
      MaterialPageRoute(builder: (_) => EditRoutineScreen(routine: _routine)),
    );
    if (updated != null && mounted) setState(() => _routine = updated);
  }

  Future<void> _addExercise() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AddExerciseScreen(
          routineId: _routine.id,
          routineName: _routine.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: KineticAppBar(
        showBackButton: true,
        actions: [
          GestureDetector(
            onTap: _openEdit,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.edit_outlined, color: cs.primary, size: 22),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
        children: [
          _HeroHeader(routine: _routine, linkService: _linkService),
          const SizedBox(height: 40),
          _ExerciseList(
            routineId: _routine.id,
            routineName: _routine.name,
            linkService: _linkService,
            onAddExercise: _addExercise,
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final Routine routine;
  final RoutineExerciseService linkService;

  const _HeroHeader({required this.routine, required this.linkService});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACTIVE ROUTINE',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
            color: cs.tertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          routine.name.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
            height: 1.0,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot<RoutineExercise>>(
          stream: linkService.observeForRoutine(routine.id),
          builder: (context, linkSnap) {
            final n = linkSnap.hasData ? linkSnap.data!.items.length : 0;
            return StreamBuilder<QuerySnapshot<WorkoutLog>>(
              stream: linkService.observeAllWorkoutLogs(),
              builder: (context, logSnap) {
                DateTime? last;
                if (linkSnap.hasData && logSnap.hasData) {
                  final map = RoutineExerciseService.lastPerformedByRoutineId(
                    links: linkSnap.data!.items,
                    logs: logSnap.data!.items,
                  );
                  last = map[routine.id];
                }
                return Row(
                  children: [
                    _MetricPill(label: 'EXERCISES', value: '$n'),
                    Container(
                      width: 1,
                      height: 32,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      color: cs.surfaceContainerHighest,
                    ),
                    _MetricPill(
                      label: 'LAST SESSION',
                      value: formatRoutineLastSessionLabel(last).toUpperCase(),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ExerciseList extends StatelessWidget {
  final String routineId;
  final String routineName;
  final RoutineExerciseService linkService;
  final VoidCallback onAddExercise;

  const _ExerciseList({
    required this.routineId,
    required this.routineName,
    required this.linkService,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<QuerySnapshot<RoutineExercise>>(
      stream: linkService.observeForRoutine(routineId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Could not load exercises',
            style: GoogleFonts.inter(color: cs.error),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final links = snapshot.data!.items;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: cs.surfaceContainerHighest),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EXERCISES',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${links.length} Total',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: cs.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (links.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'No exercises yet. Use the button below to add one.',
                  style: GoogleFonts.inter(fontSize: 14, color: cs.outline),
                ),
              )
            else
              FutureBuilder<Map<String, Exercise>>(
                key: ValueKey(links.map((e) => e.id).join(',')),
                future: linkService.exerciseMapForIds(
                  links.map((l) => l.exerciseId).toSet(),
                ),
                builder: (context, exSnap) {
                  if (!exSnap.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final map = exSnap.data!;
                  return StreamBuilder<QuerySnapshot<WorkoutLog>>(
                    stream: linkService.observeAllWorkoutLogs(),
                    builder: (context, logSnap) {
                      final logs = logSnap.data?.items ?? const <WorkoutLog>[];
                      return Column(
                        children: [
                          for (var i = 0; i < links.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _ExerciseTile(
                                exercise: map[links[i].exerciseId],
                                link: links[i],
                                listIndex: i,
                                routineName: routineName,
                                trainingLoadChangePercent:
                                    map[links[i].exerciseId]?.type != 'timer'
                                        ? SessionSetsService
                                            .trainingLoadChangePercentForLatestSession(
                                              links[i].id,
                                              logs,
                                            )
                                        : null,
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            _DashedAddExerciseButton(onPressed: onAddExercise),
          ],
        );
      },
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise? exercise;
  final RoutineExercise link;
  final int listIndex;
  final String routineName;
  final double? trainingLoadChangePercent;

  const _ExerciseTile({
    required this.exercise,
    required this.link,
    required this.listIndex,
    required this.routineName,
    this.trainingLoadChangePercent,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = exercise?.name ?? 'Unknown exercise';
    final delta = trainingLoadChangePercent;
    final subtitle = _subtitleLine(link, listIndex, exercise);
    final progress =
        delta != null ? _progressFromDeltaPercent(delta, cs.outline) : null;

    return Material(
      color: cs.surfaceContainerLowest,
      child: InkWell(
        onTap: () {
          final detailExercise = exerciseForWorkoutDetail(
            exercise,
            link,
            listIndex,
          );
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ExerciseDetailScreen(
                exercise: detailExercise,
                routineLink: exercise != null ? link : null,
                amplifyExercise: exercise,
                routineName: routineName,
                listIndex: listIndex,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.2,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: cs.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (progress != null) ...[
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: progress.dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          progress.valueLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: progress.valueColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      progress.caption,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: progress.captionColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedAddExerciseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DashedAddExerciseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: CustomPaint(
            painter: _DashedBorderPainter(color: cs.surfaceContainerHighest),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_box_outlined, size: 28, color: cs.tertiary),
                  const SizedBox(height: 8),
                  Text(
                    'ADD EXERCISE',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: cs.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dash = 6.0;
    const gap = 4.0;

    void drawDashedLine(Offset from, Offset to) {
      final total = (to - from).distance;
      if (total <= 0) return;
      final dir = (to - from) / total;
      var d = 0.0;
      while (d < total) {
        final end = d + dash > total ? total : d + dash;
        canvas.drawLine(from + dir * d, from + dir * end, paint);
        d = end + gap;
      }
    }

    drawDashedLine(rect.topLeft, rect.topRight);
    drawDashedLine(rect.bottomLeft, rect.bottomRight);
    drawDashedLine(rect.topLeft, rect.bottomLeft);
    drawDashedLine(rect.topRight, rect.bottomRight);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;

  const _MetricPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: cs.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
