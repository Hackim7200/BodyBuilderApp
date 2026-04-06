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

// NOTE: Synced with amplify/backend/api/bodybuildingapp/schema.graphql (CircuitExercise type).

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;

/** Represents the CircuitExercise type in your schema. */
class CircuitExercise extends amplify_core.Model {
  static const classType = const _CircuitExerciseModelType();
  final String id;
  final String? _circuitId;
  final String? _exerciseId;
  final int? _orderIndex;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
    '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.',
  )
  @override
  String getId() => id;

  CircuitExerciseModelIdentifier get modelIdentifier {
    return CircuitExerciseModelIdentifier(id: id);
  }

  String get circuitId {
    try {
      return _circuitId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
        amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
        recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
        underlyingException: e.toString(),
      );
    }
  }

  String get exerciseId {
    try {
      return _exerciseId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
        amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
        recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
        underlyingException: e.toString(),
      );
    }
  }

  int get orderIndex {
    try {
      return _orderIndex!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
        amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
        recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
        underlyingException: e.toString(),
      );
    }
  }

  amplify_core.TemporalDateTime? get createdAt => _createdAt;

  amplify_core.TemporalDateTime? get updatedAt => _updatedAt;

  const CircuitExercise._internal({
    required this.id,
    required String circuitId,
    required String exerciseId,
    required int orderIndex,
    amplify_core.TemporalDateTime? createdAt,
    amplify_core.TemporalDateTime? updatedAt,
  })  : _circuitId = circuitId,
        _exerciseId = exerciseId,
        _orderIndex = orderIndex,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory CircuitExercise({
    String? id,
    required String circuitId,
    required String exerciseId,
    required int orderIndex,
  }) {
    return CircuitExercise._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      circuitId: circuitId,
      exerciseId: exerciseId,
      orderIndex: orderIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CircuitExercise &&
        id == other.id &&
        _circuitId == other._circuitId &&
        _exerciseId == other._exerciseId &&
        _orderIndex == other._orderIndex;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('CircuitExercise {');
    buffer.write('id=' + id + ', ');
    buffer.write('circuitId=' + '$_circuitId' + ', ');
    buffer.write('exerciseId=' + '$_exerciseId' + ', ');
    buffer.write(
      'orderIndex=' +
          (_orderIndex != null ? _orderIndex.toString() : 'null') +
          ', ',
    );
    buffer.write(
      'createdAt=' +
          (_createdAt != null ? _createdAt.format() : 'null') +
          ', ',
    );
    buffer.write('updatedAt=' + (_updatedAt != null ? _updatedAt.format() : 'null'));
    buffer.write('}');
    return buffer.toString();
  }

  CircuitExercise copyWith({
    String? circuitId,
    String? exerciseId,
    int? orderIndex,
  }) {
    return CircuitExercise._internal(
      id: id,
      circuitId: circuitId ?? this.circuitId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  CircuitExercise copyWithModelFieldValues({
    ModelFieldValue<String>? circuitId,
    ModelFieldValue<String>? exerciseId,
    ModelFieldValue<int>? orderIndex,
  }) {
    return CircuitExercise._internal(
      id: id,
      circuitId: circuitId == null ? this.circuitId : circuitId.value,
      exerciseId: exerciseId == null ? this.exerciseId : exerciseId.value,
      orderIndex: orderIndex == null ? this.orderIndex : orderIndex.value,
    );
  }

  CircuitExercise.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _circuitId = json['circuitId'],
        _exerciseId = json['exerciseId'],
        _orderIndex = (json['orderIndex'] as num?)?.toInt(),
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'circuitId': _circuitId,
        'exerciseId': _exerciseId,
        'orderIndex': _orderIndex,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format(),
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'circuitId': _circuitId,
        'exerciseId': _exerciseId,
        'orderIndex': _orderIndex,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt,
      };

  static final amplify_core.QueryModelIdentifier<CircuitExerciseModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<CircuitExerciseModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: 'id');
  static final CIRCUITID = amplify_core.QueryField(fieldName: 'circuitId');
  static final EXERCISEID = amplify_core.QueryField(fieldName: 'exerciseId');
  static final ORDERINDEX = amplify_core.QueryField(fieldName: 'orderIndex');
  static var schema = amplify_core.Model.defineSchema(
    define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
      modelSchemaDefinition.name = 'CircuitExercise';
      modelSchemaDefinition.pluralName = 'CircuitExercises';

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: CircuitExercise.CIRCUITID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string),
      ));

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: CircuitExercise.EXERCISEID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string),
      ));

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: CircuitExercise.ORDERINDEX,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int),
      ));

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
        fieldName: 'createdAt',
        isRequired: false,
        isReadOnly: true,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime),
      ));

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
        fieldName: 'updatedAt',
        isRequired: false,
        isReadOnly: true,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime),
      ));
    },
  );
}

class _CircuitExerciseModelType extends amplify_core.ModelType<CircuitExercise> {
  const _CircuitExerciseModelType();

  @override
  CircuitExercise fromJson(Map<String, dynamic> jsonData) {
    return CircuitExercise.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'CircuitExercise';
  }
}

class CircuitExerciseModelIdentifier
    implements amplify_core.ModelIdentifier<CircuitExercise> {
  final String id;

  const CircuitExerciseModelIdentifier({required this.id});

  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{'id': id});

  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
      .entries
      .map((entry) => (<String, dynamic>{entry.key: entry.value}))
      .toList();

  @override
  String serializeAsString() => serializeAsMap().values.join('#');

  @override
  String toString() => 'CircuitExerciseModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }

    return other is CircuitExerciseModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
