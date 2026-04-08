import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bodybuilding_app/app/themes/app_theme.dart';
import 'package:bodybuilding_app/core/utils/timer_routine_target.dart';
import 'package:bodybuilding_app/feature/exercise/models/exercise.dart';

class TimerExerciseDashboard extends StatefulWidget {
  final Exercise exercise;

  const TimerExerciseDashboard({super.key, required this.exercise});

  @override
  State<TimerExerciseDashboard> createState() => _TimerExerciseDashboardState();
}

class _TimerExerciseDashboardState extends State<TimerExerciseDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRunning = false;
  Duration _elapsed = Duration.zero;

  static const _dummyElapsed = Duration(minutes: 1, seconds: 42);
  static const _dummyPB = Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
    _elapsed = _dummyElapsed;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _progress {
    final target = widget.exercise.duration ?? _dummyPB;
    return (_elapsed.inMilliseconds / target.inMilliseconds).clamp(0.0, 1.0);
  }

  String get _timeString {
    final minutes = _elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Timer Ring
        SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(
              painter: _TimerRingPainter(
                progress: _progress,
                trackColor: cs.surfaceContainerHigh,
                progressColor: cs.primary,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _timeString,
                      style: GoogleFonts.inter(
                        fontSize: 80,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -4,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'PB: ${_formatDuration(_dummyPB)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            color: cs.tertiary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cs.error,
                          ),
                        ),
                      ],
                    ),
                    if (widget.exercise.sets > 0) ...[
                      const SizedBox(height: 10),
                      Text(
                        '${widget.exercise.sets} SETS',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: cs.outline,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'TARGET: ${TimerRoutineTarget.label(widget.exercise.timerTarget).toUpperCase()}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: cs.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Control Buttons
        Row(
          children: [
            Expanded(
              child: _ControlButton(
                icon: Icons.refresh,
                label: 'RESET',
                isPrimary: false,
                onTap: () => setState(() => _elapsed = Duration.zero),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ControlButton(
                icon: _isRunning ? Icons.stop : Icons.play_arrow,
                label: _isRunning ? 'STOP' : 'START',
                isPrimary: true,
                onTap: () => setState(() => _isRunning = !_isRunning),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ControlButton(
                icon: Icons.save,
                label: 'COMPLETE',
                isPrimary: false,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Metrics
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: cs.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PERCENTAGE CHANGE',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: cs.tertiary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+2.5%',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 1),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: cs.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MAX TIME',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: cs.tertiary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '02:15 ',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: 'MIN',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cs.primary, cs.primaryContainer],
                )
              : null,
          color: isPrimary ? null : cs.surfaceContainer,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: isPrimary ? 28 : 22,
              color: isPrimary ? cs.onPrimary : cs.onSurface,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: isPrimary ? cs.onPrimary : cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _TimerRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 4;
    const strokeWidth = 3.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    canvas.drawCircle(center, radius, trackPaint);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      trackColor != oldDelegate.trackColor ||
      progressColor != oldDelegate.progressColor;
}
