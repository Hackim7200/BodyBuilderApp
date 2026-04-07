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


/** This is an auto generated class representing the SetEntry type in your schema. */
class SetEntry extends amplify_core.Model {
  static const classType = const _SetEntryModelType();
  final String id;
  final String? _workoutLogId;
  final int? _setNumber;
  final double? _weight;
  final int? _reps;
  final double? _trainingLoad;
  final int? _durationSeconds;
  final bool? _isCompleted;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SetEntryModelIdentifier get modelIdentifier {
      return SetEntryModelIdentifier(
        id: id
      );
  }
  
  String get workoutLogId {
    try {
      return _workoutLogId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get setNumber {
    try {
      return _setNumber!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double? get weight {
    return _weight;
  }
  
  int? get reps {
    return _reps;
  }

  double? get trainingLoad {
    return _trainingLoad;
  }
  
  int? get durationSeconds {
    return _durationSeconds;
  }
  
  bool? get isCompleted {
    return _isCompleted;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const SetEntry._internal({required this.id, required workoutLogId, required setNumber, weight, reps, trainingLoad, durationSeconds, isCompleted, createdAt, updatedAt}): _workoutLogId = workoutLogId, _setNumber = setNumber, _weight = weight, _reps = reps, _trainingLoad = trainingLoad, _durationSeconds = durationSeconds, _isCompleted = isCompleted, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SetEntry({String? id, required String workoutLogId, required int setNumber, double? weight, int? reps, double? trainingLoad, int? durationSeconds, bool? isCompleted}) {
    return SetEntry._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      workoutLogId: workoutLogId,
      setNumber: setNumber,
      weight: weight,
      reps: reps,
      trainingLoad: trainingLoad,
      durationSeconds: durationSeconds,
      isCompleted: isCompleted);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetEntry &&
      id == other.id &&
      _workoutLogId == other._workoutLogId &&
      _setNumber == other._setNumber &&
      _weight == other._weight &&
      _reps == other._reps &&
      _trainingLoad == other._trainingLoad &&
      _durationSeconds == other._durationSeconds &&
      _isCompleted == other._isCompleted;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SetEntry {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("workoutLogId=" + "$_workoutLogId" + ", ");
    buffer.write("setNumber=" + (_setNumber != null ? _setNumber!.toString() : "null") + ", ");
    buffer.write("weight=" + (_weight != null ? _weight!.toString() : "null") + ", ");
    buffer.write("reps=" + (_reps != null ? _reps!.toString() : "null") + ", ");
    buffer.write("trainingLoad=" + (_trainingLoad != null ? _trainingLoad!.toString() : "null") + ", ");
    buffer.write("durationSeconds=" + (_durationSeconds != null ? _durationSeconds!.toString() : "null") + ", ");
    buffer.write("isCompleted=" + (_isCompleted != null ? _isCompleted!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SetEntry copyWith({String? workoutLogId, int? setNumber, double? weight, int? reps, double? trainingLoad, int? durationSeconds, bool? isCompleted}) {
    return SetEntry._internal(
      id: id,
      workoutLogId: workoutLogId ?? this.workoutLogId,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      trainingLoad: trainingLoad ?? this.trainingLoad,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isCompleted: isCompleted ?? this.isCompleted);
  }
  
  SetEntry copyWithModelFieldValues({
    ModelFieldValue<String>? workoutLogId,
    ModelFieldValue<int>? setNumber,
    ModelFieldValue<double?>? weight,
    ModelFieldValue<int?>? reps,
    ModelFieldValue<double?>? trainingLoad,
    ModelFieldValue<int?>? durationSeconds,
    ModelFieldValue<bool?>? isCompleted
  }) {
    return SetEntry._internal(
      id: id,
      workoutLogId: workoutLogId == null ? this.workoutLogId : workoutLogId.value,
      setNumber: setNumber == null ? this.setNumber : setNumber.value,
      weight: weight == null ? this.weight : weight.value,
      reps: reps == null ? this.reps : reps.value,
      trainingLoad: trainingLoad == null ? this.trainingLoad : trainingLoad.value,
      durationSeconds: durationSeconds == null ? this.durationSeconds : durationSeconds.value,
      isCompleted: isCompleted == null ? this.isCompleted : isCompleted.value
    );
  }
  
  SetEntry.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _workoutLogId = json['workoutLogId'],
      _setNumber = (json['setNumber'] as num?)?.toInt(),
      _weight = (json['weight'] as num?)?.toDouble(),
      _reps = (json['reps'] as num?)?.toInt(),
      _trainingLoad = (json['trainingLoad'] as num?)?.toDouble(),
      _durationSeconds = (json['durationSeconds'] as num?)?.toInt(),
      _isCompleted = json['isCompleted'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'workoutLogId': _workoutLogId, 'setNumber': _setNumber, 'weight': _weight, 'reps': _reps, 'trainingLoad': _trainingLoad, 'durationSeconds': _durationSeconds, 'isCompleted': _isCompleted, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'workoutLogId': _workoutLogId,
    'setNumber': _setNumber,
    'weight': _weight,
    'reps': _reps,
    'trainingLoad': _trainingLoad,
    'durationSeconds': _durationSeconds,
    'isCompleted': _isCompleted,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SetEntryModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SetEntryModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final WORKOUTLOGID = amplify_core.QueryField(fieldName: "workoutLogId");
  static final SETNUMBER = amplify_core.QueryField(fieldName: "setNumber");
  static final WEIGHT = amplify_core.QueryField(fieldName: "weight");
  static final REPS = amplify_core.QueryField(fieldName: "reps");
  static final TRAININGLOAD = amplify_core.QueryField(fieldName: "trainingLoad");
  static final DURATIONSECONDS = amplify_core.QueryField(fieldName: "durationSeconds");
  static final ISCOMPLETED = amplify_core.QueryField(fieldName: "isCompleted");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SetEntry";
    modelSchemaDefinition.pluralName = "SetEntries";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SetEntry.WORKOUTLOGID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SetEntry.SETNUMBER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SetEntry.WEIGHT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SetEntry.REPS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SetEntry.TRAININGLOAD,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SetEntry.DURATIONSECONDS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SetEntry.ISCOMPLETED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
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

class _SetEntryModelType extends amplify_core.ModelType<SetEntry> {
  const _SetEntryModelType();
  
  @override
  SetEntry fromJson(Map<String, dynamic> jsonData) {
    return SetEntry.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'SetEntry';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SetEntry] in your schema.
 */
class SetEntryModelIdentifier implements amplify_core.ModelIdentifier<SetEntry> {
  final String id;

  /** Create an instance of SetEntryModelIdentifier using [id] the primary key. */
  const SetEntryModelIdentifier({
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
  String toString() => 'SetEntryModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SetEntryModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}