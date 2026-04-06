import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Stored on [Routine.focus] as the short title (e.g. `Hypertrophy`).
const List<RoutineFocusOption> kRoutineFocusOptions = [
  RoutineFocusOption(
    value: 'Hypertrophy',
    menuLabel: 'Hypertrophy (get bigger)',
  ),
  RoutineFocusOption(
    value: 'Strength',
    menuLabel: 'Strength (get stronger)',
  ),
  RoutineFocusOption(
    value: 'Endurance',
    menuLabel: 'Endurance (last longer)',
  ),
  RoutineFocusOption(
    value: 'Conditioning',
    menuLabel: 'Conditioning (overall fitness)',
  ),
];

class RoutineFocusOption {
  final String value;
  final String menuLabel;

  const RoutineFocusOption({required this.value, required this.menuLabel});
}

/// Normalizes legacy or mixed-case [Routine.focus] to a known option value, or null.
String? routineFocusValueFromStored(String? stored) {
  if (stored == null || stored.trim().isEmpty) return null;
  final t = stored.trim();
  for (final o in kRoutineFocusOptions) {
    if (o.value.toLowerCase() == t.toLowerCase()) return o.value;
  }
  return null;
}

/// Underline dropdown matching create/edit routine text fields.
class RoutineFocusSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const RoutineFocusSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FOCUS',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: cs.tertiary,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          value: value,
          isExpanded: true,
          hint: Text(
            'Select focus',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: cs.outlineVariant,
            ),
          ),
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.only(bottom: 12),
          ),
          dropdownColor: cs.surface,
          icon: Icon(Icons.expand_more, color: cs.onSurface),
          items: kRoutineFocusOptions
              .map(
                (o) => DropdownMenuItem<String?>(
                  value: o.value,
                  child: Text(
                    o.menuLabel,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
