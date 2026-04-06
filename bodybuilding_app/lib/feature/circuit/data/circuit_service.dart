import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bodybuilding_app/models/Circuit.dart';
import 'package:bodybuilding_app/models/CircuitExercise.dart';
import 'package:bodybuilding_app/models/Exercise.dart';

class CircuitService {
  Future<void> saveCircuit(Circuit circuit) async {
    await Amplify.DataStore.save(circuit);
  }

  Stream<QuerySnapshot<Circuit>> observeCircuits() {
    return Amplify.DataStore.observeQuery(Circuit.classType);
  }

  /// Deletes a circuit and all linked exercises (circuit-specific [Exercise] rows).
  Future<void> deleteCircuit(Circuit circuit) async {
    final links = await Amplify.DataStore.query(
      CircuitExercise.classType,
      where: CircuitExercise.CIRCUITID.eq(circuit.id),
    );

    for (final link in links) {
      final ex = await Amplify.DataStore.query(
        Exercise.classType,
        where: Exercise.ID.eq(link.exerciseId),
      );
      await Amplify.DataStore.delete(link);
      if (ex.isNotEmpty) {
        await Amplify.DataStore.delete(ex.first);
      }
    }

    await Amplify.DataStore.delete(circuit);
  }
}
