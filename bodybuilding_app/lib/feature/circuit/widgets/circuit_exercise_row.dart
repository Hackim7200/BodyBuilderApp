import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircuitExerciseData {
  final int index;
  final String name;
  final String duration;

  const CircuitExerciseData({
    required this.index,
    required this.name,
    required this.duration,
  });
}

class CircuitExerciseRow extends StatelessWidget {
  final CircuitExerciseData data;

  const CircuitExerciseRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              '${data.index.toString().padLeft(2, '0')}.',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: cs.outlineVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              data.name.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: cs.primary,
              ),
            ),
          ),
          Text(
            data.duration,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: cs.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
