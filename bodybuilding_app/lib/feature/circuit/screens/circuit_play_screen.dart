import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bodybuilding_app/core/widgets/kinetic_app_bar.dart';
import 'package:bodybuilding_app/feature/circuit/data/circuit_exercise_service.dart';
import 'package:bodybuilding_app/models/Circuit.dart';

/// Runs a circuit: same station duration for each exercise, optional rounds.
class CircuitPlayScreen extends StatefulWidget {
  final Circuit circuit;

  const CircuitPlayScreen({super.key, required this.circuit});

  @override
  State<CircuitPlayScreen> createState() => _CircuitPlayScreenState();
}

class _CircuitPlayScreenState extends State<CircuitPlayScreen> {
  final _linkService = CircuitExerciseService();
  late final AudioPlayer _beepPlayer;
  List<String> _stationNames = [];
  bool _loading = true;
  String? _loadError;

  int _roundIndex = 0;
  int _stationIndex = 0;
  int _secondsLeft = 0;
  bool _running = false;
  bool _finished = false;
  Timer? _timer;

  int get _stationSec =>
      widget.circuit.stationDurationSeconds?.clamp(1, 3600) ?? 30;

  int get _totalRounds => (widget.circuit.rounds ?? 1).clamp(1, 999);

  Future<void> _playBeep({bool long = false}) async {
    final path = long ? 'sounds/beep_long.wav' : 'sounds/beep.wav';
    try {
      await _beepPlayer.stop();
      await _beepPlayer.play(AssetSource(path));
    } catch (_) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Three long beeps when the full circuit is done.
  ///
  /// Uses fixed delays instead of [onPlayerComplete], which is unreliable with
  /// [stop]/asset playback on some Android/iOS builds (often only one beep is heard).
  Future<void> _playTripleLongBeeps() async {
    // assets/sounds/beep_long.wav is 0.55s; pad for decoder/device variance.
    const toneHold = Duration(milliseconds: 620);
    const gapBetween = Duration(milliseconds: 240);
    try {
      for (var i = 0; i < 3; i++) {
        if (!mounted) return;
        await _beepPlayer.stop();
        await Future<void>.delayed(const Duration(milliseconds: 60));
        await _beepPlayer.play(AssetSource('sounds/beep_long.wav'));
        await Future<void>.delayed(toneHold);
        if (i < 2) await Future<void>.delayed(gapBetween);
      }
    } catch (_) {
      for (var i = 0; i < 3; i++) {
        if (!mounted) return;
        SystemSound.play(SystemSoundType.alert);
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  void _startPeriodicTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  @override
  void initState() {
    super.initState();
    _beepPlayer = AudioPlayer();
    unawaited(_beepPlayer.setReleaseMode(ReleaseMode.stop));
    _loadStations();
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_beepPlayer.dispose());
    super.dispose();
  }

  Future<void> _loadStations() async {
    try {
      final links = await _linkService.linksForCircuit(widget.circuit.id);
      final map = await _linkService.exerciseMapForIds(
        links.map((l) => l.exerciseId).toSet(),
      );
      final names = links
          .map((l) => map[l.exerciseId]?.name.trim() ?? 'Station')
          .where((n) => n.isNotEmpty)
          .toList();
      final playOrder = List<String>.from(names);
      if (widget.circuit.randomizeStationOrder == true && playOrder.length > 1) {
        playOrder.shuffle(Random());
      }
      if (!mounted) return;
      setState(() {
        _stationNames = playOrder;
        _loading = false;
        _secondsLeft = _stationSec;
        _running = playOrder.isNotEmpty;
      });
      if (playOrder.isNotEmpty) {
        _startPeriodicTimer();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          HapticFeedback.mediumImpact();
          unawaited(_playBeep(long: true));
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = '$e';
        _loading = false;
      });
    }
  }

  void _tick(Timer t) {
    if (!_running || _finished) return;
    if (_secondsLeft > 1) {
      setState(() => _secondsLeft--);
      return;
    }
    _advanceStation();
  }

  void _advanceStation() {
    final n = _stationNames.length;
    if (n == 0) return;

    var nextStation = _stationIndex + 1;
    var nextRound = _roundIndex;
    if (nextStation >= n) {
      nextStation = 0;
      nextRound++;
      if (nextRound >= _totalRounds) {
        _timer?.cancel();
        HapticFeedback.heavyImpact();
        unawaited(_playTripleLongBeeps());
        setState(() {
          _finished = true;
          _running = false;
          _secondsLeft = 0;
        });
        return;
      }
    }

    unawaited(_playBeep());
    setState(() {
      _stationIndex = nextStation;
      _roundIndex = nextRound;
      _secondsLeft = _stationSec;
    });
  }

  void _toggleRun() {
    if (_finished || _stationNames.isEmpty) return;
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
      return;
    }
    setState(() => _running = true);
    _startPeriodicTimer();
  }

  void _skipStation() {
    if (_finished || _stationNames.isEmpty) return;
    _advanceStation();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = _stationNames.isEmpty
        ? '—'
        : _stationNames[_stationIndex.clamp(0, _stationNames.length - 1)];

    return Scaffold(
      appBar: KineticAppBar(
        title: 'CIRCUIT',
        showBackButton: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _loadError!,
                      style: GoogleFonts.inter(color: cs.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _stationNames.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Add exercises to this circuit before playing.',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: cs.outline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.circuit.name.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: cs.outline,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              height: 1.1,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Round ${_roundIndex + 1} of $_totalRounds · '
                            'Station ${_stationIndex + 1} of ${_stationNames.length}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: cs.tertiary,
                            ),
                          ),
                          const Spacer(),
                          if (_finished) ...[
                            Text(
                              'CIRCUIT COMPLETE',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                                color: cs.primary,
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  foregroundColor: cs.primary,
                                  side: BorderSide(
                                    color: cs.primary,
                                    width: 2,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text(
                                  'EXIT',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3,
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            Text(
                              '$_secondsLeft',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 96,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -4,
                                color: cs.primary,
                                height: 1,
                              ),
                            ),
                            Text(
                              'SECONDS',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 3,
                                color: cs.outline,
                              ),
                            ),
                          ],
                          const Spacer(),
                          if (!_finished)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FilledButton.tonal(
                                  onPressed: _skipStation,
                                  child: Text(
                                    'SKIP',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                FilledButton(
                                  onPressed: _toggleRun,
                                  child: Icon(
                                    _running ? Icons.pause : Icons.play_arrow,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
    );
  }
}
