import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bodybuilding_app/core/widgets/empty_state_widget.dart';
import 'package:bodybuilding_app/core/widgets/kinetic_app_bar.dart';
import 'package:bodybuilding_app/feature/routine/data/routine_exercise_service.dart';
import 'package:bodybuilding_app/feature/routine/data/routine_service.dart';
import 'package:bodybuilding_app/models/RoutineExercise.dart';
import 'package:bodybuilding_app/models/routine.dart';
import 'package:bodybuilding_app/feature/routine/widgets/routine_card.dart';
import 'package:bodybuilding_app/feature/routine/widgets/create_routine_card.dart';
import 'package:bodybuilding_app/feature/exercise/screens/exercise_dashboard_screen.dart';
import 'package:bodybuilding_app/feature/routine/screens/create_routine_screen.dart';

class RoutineDashboardScreen extends StatefulWidget {
  const RoutineDashboardScreen({super.key});

  @override
  State<RoutineDashboardScreen> createState() =>
      _RoutineDashboardScreenState();
}

class _RoutineDashboardScreenState extends State<RoutineDashboardScreen> {
  final _service = RoutineService();
  final _linkService = RoutineExerciseService();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const KineticAppBar(showProfileButton: true),
      body: StreamBuilder<QuerySnapshot<Routine>>(
        stream: _service.observeRoutines(),
        builder: (context, routineSnap) {
          if (routineSnap.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: GoogleFonts.inter(color: cs.error),
              ),
            );
          }

          if (!routineSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final routines = routineSnap.data!.items;

          if (routines.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.fitness_center,
              title: 'No routines yet',
              subtitle:
                  'Create a routine (e.g. Push Day) and add exercises from the detail screen.',
              actionLabel: 'Create routine',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CreateRoutineScreen(),
                ),
              ),
            );
          }

          return StreamBuilder<QuerySnapshot<RoutineExercise>>(
            stream: _linkService.observeAllRoutineExerciseLinks(),
            builder: (context, linkSnap) {
              final counts = linkSnap.hasData
                  ? RoutineExerciseService.exerciseCountsByRoutineId(
                      linkSnap.data!.items,
                    )
                  : <String, int>{};

              return ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'ACTIVE ROUTINES',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: cs.primary,
                        ),
                      ),
                      Text(
                        '${routines.length} Total',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: cs.tertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...routines.map(
                    (routine) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: RoutineCard(
                        routine: routine,
                        exerciseCount: counts[routine.id] ?? 0,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                RoutineDetailScreen(routine: routine),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CreateRoutineCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CreateRoutineScreen(),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
