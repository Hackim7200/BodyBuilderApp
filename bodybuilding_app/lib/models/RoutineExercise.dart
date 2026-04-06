/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the RoutineExercise type in your schema. */
class RoutineExercise extends amplify_core.Model {
  static const classType = const _RoutineExerciseModelType();
  final String id;
  final String? _routineId;
  final String? _exerciseId;
  final int? _orderIndex;
  final int? _targetSets;
  final String? _targetReps;
  final int? _restSeconds;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  RoutineExerciseModelIdentifier get modelIdentifier {
      return RoutineExerciseModelIdentifier(
        id: id
      );
  }
  
  String get routineId {
    try {
      return _routineId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get exerciseId {
    try {
      return _exerciseId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get orderIndex {
    try {
      return _orderIndex!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int? get targetSets {
    return _targetSets;
  }
  
  String? get targetReps {
    return _targetReps;
  }
  
  int? get restSeconds {
    return _restSeconds;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const RoutineExercise._internal({required this.id, required routineId, required exerciseId, required orderIndex, targetSets, targetReps, restSeconds, createdAt, updatedAt}): _routineId = routineId, _exerciseId = exerciseId, _orderIndex = orderIndex, _targetSets = targetSets, _targetReps = targetReps, _restSeconds = restSeconds, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory RoutineExercise({String? id, required String routineId, required String exerciseId, required int orderIndex, int? targetSets, String? targetReps, int? restSeconds}) {
    return RoutineExercise._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      routineId: routineId,
      exerciseId: exerciseId,
      orderIndex: orderIndex,
      targetSets: targetSets,
      targetReps: targetReps,
      restSeconds: restSeconds);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoutineExercise &&
      id == other.id &&
      _routineId == other._routineId &&
      _exerciseId == other._exerciseId &&
      _orderIndex == other._orderIndex &&
      _targetSets == other._targetSets &&
      _targetReps == other._targetReps &&
      _restSeconds == other._restSeconds;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("RoutineExercise {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("routineId=" + "$_routineId" + ", ");
    buffer.write("exerciseId=" + "$_exerciseId" + ", ");
    buffer.write("orderIndex=" + (_orderIndex != null ? _orderIndex!.toString() : "null") + ", ");
    buffer.write("targetSets=" + (_targetSets != null ? _targetSets!.toString() : "null") + ", ");
    buffer.write("targetReps=" + "$_targetReps" + ", ");
    buffer.write("restSeconds=" + (_restSeconds != null ? _restSeconds!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  RoutineExercise copyWith({String? routineId, String? exerciseId, int? orderIndex, int? targetSets, String? targetReps, int? restSeconds}) {
    return RoutineExercise._internal(
      id: id,
      routineId: routineId ?? this.routineId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
      restSeconds: restSeconds ?? this.restSeconds);
  }
  
  RoutineExercise copyWithModelFieldValues({
    ModelFieldValue<String>? routineId,
    ModelFieldValue<String>? exerciseId,
    ModelFieldValue<int>? orderIndex,
    ModelFieldValue<int?>? targetSets,
    ModelFieldValue<String?>? targetReps,
    ModelFieldValue<int?>? restSeconds
  }) {
    return RoutineExercise._internal(
      id: id,
      routineId: routineId == null ? this.routineId : routineId.value,
      exerciseId: exerciseId == null ? this.exerciseId : exerciseId.value,
      orderIndex: orderIndex == null ? this.orderIndex : orderIndex.value,
      targetSets: targetSets == null ? this.targetSets : targetSets.value,
      targetReps: targetReps == null ? this.targetReps : targetReps.value,
      restSeconds: restSeconds == null ? this.restSeconds : restSeconds.value
    );
  }
  
  RoutineExercise.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _routineId = json['routineId'],
      _exerciseId = json['exerciseId'],
      _orderIndex = (json['orderIndex'] as num?)?.toInt(),
      _targetSets = (json['targetSets'] as num?)?.toInt(),
      _targetReps = json['targetReps'],
      _restSeconds = (json['restSeconds'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'routineId': _routineId, 'exerciseId': _exerciseId, 'orderIndex': _orderIndex, 'targetSets': _targetSets, 'targetReps': _targetReps, 'restSeconds': _restSeconds, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'routineId': _routineId,
    'exerciseId': _exerciseId,
    'orderIndex': _orderIndex,
    'targetSets': _targetSets,
    'targetReps': _targetReps,
    'restSeconds': _restSeconds,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<RoutineExerciseModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<RoutineExerciseModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ROUTINEID = amplify_core.QueryField(fieldName: "routineId");
  static final EXERCISEID = amplify_core.QueryField(fieldName: "exerciseId");
  static final ORDERINDEX = amplify_core.QueryField(fieldName: "orderIndex");
  static final TARGETSETS = amplify_core.QueryField(fieldName: "targetSets");
  static final TARGETREPS = amplify_core.QueryField(fieldName: "targetReps");
  static final RESTSECONDS = amplify_core.QueryField(fieldName: "restSeconds");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "RoutineExercise";
    modelSchemaDefinition.pluralName = "RoutineExercises";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutineExercise.ROUTINEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutineExercise.EXERCISEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutineExercise.ORDERINDEX,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutineExercise.TARGETSETS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutineExercise.TARGETREPS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutineExercise.RESTSECONDS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _RoutineExerciseModelType extends amplify_core.ModelType<RoutineExercise> {
  const _RoutineExerciseModelType();
  
  @override
  RoutineExercise fromJson(Map<String, dynamic> jsonData) {
    return RoutineExercise.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'RoutineExercise';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [RoutineExercise] in your schema.
 */
class RoutineExerciseModelIdentifier implements amplify_core.ModelIdentifier<RoutineExercise> {
  final String id;

  /** Create an instance of RoutineExerciseModelIdentifier using [id] the primary key. */
  const RoutineExerciseModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'RoutineExerciseModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is RoutineExerciseModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}