import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bodybuilding_app/models/CircuitExercise.dart';
import 'package:bodybuilding_app/models/Exercise.dart';
import 'package:bodybuilding_app/models/ModelProvider.dart' show ModelFieldValue;

class CircuitExerciseService {
  Stream<QuerySnapshot<CircuitExercise>> observeAllCircuitExerciseLinks() {
    return Amplify.DataStore.observeQuery(CircuitExercise.classType);
  }

  static Map<String, int> exerciseCountsByCircuitId(
    List<CircuitExercise> links,
  ) {
    final map = <String, int>{};
    for (final link in links) {
      map.update(link.circuitId, (c) => c + 1, ifAbsent: () => 1);
    }
    return map;
  }

  Stream<QuerySnapshot<CircuitExercise>> observeForCircuit(String circuitId) {
    return Amplify.DataStore.observeQuery(
      CircuitExercise.classType,
      where: CircuitExercise.CIRCUITID.eq(circuitId),
      sortBy: [CircuitExercise.ORDERINDEX.ascending()],
    );
  }

  Future<List<CircuitExercise>> linksForCircuit(String circuitId) async {
    return Amplify.DataStore.query(
      CircuitExercise.classType,
      where: CircuitExercise.CIRCUITID.eq(circuitId),
      sortBy: [CircuitExercise.ORDERINDEX.ascending()],
    );
  }

  Future<Map<String, Exercise>> exerciseMapForIds(Set<String> ids) async {
    if (ids.isEmpty) return {};
    final all = await Amplify.DataStore.query(Exercise.classType);
    return {for (final e in all) if (ids.contains(e.id)) e.id: e};
  }

  Future<void> addExerciseToCircuit({
    required String circuitId,
    required String name,
  }) async {
    final links = await linksForCircuit(circuitId);
    final nextOrder = links.isEmpty ? 0 : links.last.orderIndex + 1;

    final exercise = Exercise(
      name: name.trim(),
      type: 'timer',
    );
    await Amplify.DataStore.save(exercise);

    final link = CircuitExercise(
      circuitId: circuitId,
      exerciseId: exercise.id,
      orderIndex: nextOrder,
    );
    await Amplify.DataStore.save(link);
  }

  Future<void> removeLink(CircuitExercise link) async {
    await Amplify.DataStore.delete(link);
  }

  Future<void> updateExerciseInCircuit({
    required Exercise exercise,
    required String name,
  }) async {
    final updatedExercise = exercise.copyWithModelFieldValues(
      name: ModelFieldValue.value(name.trim()),
    );
    await Amplify.DataStore.save(updatedExercise);
  }

  Future<void> deleteExerciseEntry({
    required CircuitExercise link,
    required Exercise exercise,
  }) async {
    await Amplify.DataStore.delete(link);
    await Amplify.DataStore.delete(exercise);
  }
}
