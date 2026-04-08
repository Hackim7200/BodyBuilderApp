/// Values stored on [RoutineExercise.timerTarget] for timer exercises.
class TimerRoutineTarget {
  TimerRoutineTarget._();

  static const increase = 'increase';
  static const decrease = 'decrease';

  static bool isValid(String? v) => v == increase || v == decrease;

  static String label(String? stored) {
    if (stored == decrease) return 'Decrease';
    return 'Increase';
  }
}
