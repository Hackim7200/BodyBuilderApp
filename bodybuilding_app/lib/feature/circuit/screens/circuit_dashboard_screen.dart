import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bodybuilding_app/core/widgets/kinetic_app_bar.dart';
import 'package:bodybuilding_app/feature/circuit/widgets/circuit_card.dart';
import 'package:bodybuilding_app/feature/circuit/widgets/circuit_exercise_row.dart';

class CircuitDashboardScreen extends StatelessWidget {
  const CircuitDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const KineticAppBar(
        title: 'THE KINETIC ARCHIVE',
        showProfileButton: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
            children: [
              // Section Header
              Text(
                'CURRENT PROTOCOL',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  color: cs.outline,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      'ACTIVE\nCIRCUITS',
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                        height: 1.1,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    color: cs.surfaceContainerHighest,
                    child: Text(
                      'VOL.\n04',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Primary Circuit Card
              const CircuitCard(
                title: 'HIIT BLAST',
                subtitle: 'Metabolic Conditioning',
                rounds: 3,
                exercises: [
                  CircuitExerciseData(index: 1, name: 'Jump Squats', duration: '45 SEC'),
                  CircuitExerciseData(index: 2, name: 'Mountain Climbers', duration: '45 SEC'),
                  CircuitExerciseData(index: 3, name: 'Plank', duration: '60 SEC'),
                ],
                totalDuration: '15 MIN',
                intensityLevel: 'HIGH',
                isHighIntensity: true,
              ),
              const SizedBox(height: 24),

              // Secondary Circuit Quick Look
              _buildSecondaryCircuit(cs),
            ],
          ),

          // FAB
          Positioned(
            bottom: 100,
            right: 24,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: cs.onSurface.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 28, color: cs.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryCircuit(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: cs.surfaceContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CORE STABILITY',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '12 MIN • 4 EXERCISES • 2 ROUNDS',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: cs.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: cs.primary,
          ),
        ],
      ),
    );
  }
}
