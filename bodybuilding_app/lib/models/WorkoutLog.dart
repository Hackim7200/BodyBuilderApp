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

import 'model_field_value.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;

/** This is an auto generated class representing the WorkoutLog type in your schema. */
class WorkoutLog extends amplify_core.Model {
  static const classType = const _WorkoutLogModelType();
  final String id;
  final String? _routineExerciseId;
  final amplify_core.TemporalDateTime? _date;
  final String? _notes;
  final double? _trainingLoadChangePercent;
  final double? _totalTrainingLoad;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
    '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.',
  )
  @override
  String getId() => id;

  WorkoutLogModelIdentifier get modelIdentifier {
    return WorkoutLogModelIdentifier(id: id);
  }

  String get routineExerciseId {
    try {
      return _routineExerciseId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
        amplify_core
            .AmplifyExceptionMessages
            .codeGenRequiredFieldForceCastExceptionMessage,
        recoverySuggestion: amplify_core
            .AmplifyExceptionMessages
            .codeGenRequiredFieldForceCastRecoverySuggestion,
        underlyingException: e.toString(),
      );
    }
  }

  amplify_core.TemporalDateTime get date {
    try {
      return _date!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
        amplify_core
            .AmplifyExceptionMessages
            .codeGenRequiredFieldForceCastExceptionMessage,
        recoverySuggestion: amplify_core
            .AmplifyExceptionMessages
            .codeGenRequiredFieldForceCastRecoverySuggestion,
        underlyingException: e.toString(),
      );
    }
  }

  String? get notes {
    return _notes;
  }

  double? get trainingLoadChangePercent {
    return _trainingLoadChangePercent;
  }

  double? get totalTrainingLoad {
    return _totalTrainingLoad;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const WorkoutLog._internal({
    required this.id,
    required routineExerciseId,
    required date,
    notes,
    trainingLoadChangePercent,
    totalTrainingLoad,
    createdAt,
    updatedAt,
  }) : _routineExerciseId = routineExerciseId,
       _date = date,
       _notes = notes,
       _trainingLoadChangePercent = trainingLoadChangePercent,
       _totalTrainingLoad = totalTrainingLoad,
       _createdAt = createdAt,
       _updatedAt = updatedAt;

  factory WorkoutLog({
    String? id,
    required String routineExerciseId,
    required amplify_core.TemporalDateTime date,
    String? notes,
    double? trainingLoadChangePercent,
    double? totalTrainingLoad,
  }) {
    return WorkoutLog._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      routineExerciseId: routineExerciseId,
      date: date,
      notes: notes,
      trainingLoadChangePercent: trainingLoadChangePercent,
      totalTrainingLoad: totalTrainingLoad,
    );
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutLog &&
        id == other.id &&
        _routineExerciseId == other._routineExerciseId &&
        _date == other._date &&
        _notes == other._notes &&
        _trainingLoadChangePercent == other._trainingLoadChangePercent &&
        _totalTrainingLoad == other._totalTrainingLoad;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("WorkoutLog {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("routineExerciseId=" + "$_routineExerciseId" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("notes=" + "$_notes" + ", ");
    buffer.write(
      "trainingLoadChangePercent=" +
          (_trainingLoadChangePercent != null
              ? _trainingLoadChangePercent.toString()
              : "null") +
          ", ",
    );
    buffer.write(
      "totalTrainingLoad=" +
          (_totalTrainingLoad != null ? _totalTrainingLoad.toString() : "null") +
          ", ",
    );
    buffer.write(
      "createdAt=" +
          (_createdAt != null ? _createdAt!.format() : "null") +
          ", ",
    );
    buffer.write(
      "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"),
    );
    buffer.write("}");

    return buffer.toString();
  }

  WorkoutLog copyWith({
    String? routineExerciseId,
    amplify_core.TemporalDateTime? date,
    String? notes,
    double? trainingLoadChangePercent,
    double? totalTrainingLoad,
  }) {
    return WorkoutLog._internal(
      id: id,
      routineExerciseId: routineExerciseId ?? this.routineExerciseId,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      trainingLoadChangePercent:
          trainingLoadChangePercent ?? this.trainingLoadChangePercent,
      totalTrainingLoad: totalTrainingLoad ?? this.totalTrainingLoad,
      createdAt: _createdAt,
      updatedAt: _updatedAt,
    );
  }

  WorkoutLog copyWithModelFieldValues({
    ModelFieldValue<String>? routineExerciseId,
    ModelFieldValue<amplify_core.TemporalDateTime>? date,
    ModelFieldValue<String?>? notes,
    ModelFieldValue<double?>? trainingLoadChangePercent,
    ModelFieldValue<double?>? totalTrainingLoad,
  }) {
    return WorkoutLog._internal(
      id: id,
      routineExerciseId: routineExerciseId == null
          ? this.routineExerciseId
          : routineExerciseId.value,
      date: date == null ? this.date : date.value,
      notes: notes == null ? this.notes : notes.value,
      trainingLoadChangePercent: trainingLoadChangePercent == null
          ? this.trainingLoadChangePercent
          : trainingLoadChangePercent.value,
      totalTrainingLoad: totalTrainingLoad == null
          ? this.totalTrainingLoad
          : totalTrainingLoad.value,
      createdAt: _createdAt,
      updatedAt: _updatedAt,
    );
  }

  WorkoutLog.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      _routineExerciseId = json['routineExerciseId'],
      _date = json['date'] != null
          ? amplify_core.TemporalDateTime.fromString(json['date'])
          : null,
      _notes = json['notes'],
      _trainingLoadChangePercent =
          (json['trainingLoadChangePercent'] as num?)?.toDouble(),
      _totalTrainingLoad = (json['totalTrainingLoad'] as num?)?.toDouble(),
      _createdAt = json['createdAt'] != null
          ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
          : null,
      _updatedAt = json['updatedAt'] != null
          ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
          : null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'routineExerciseId': _routineExerciseId,
    'date': _date?.format(),
    'notes': _notes,
    'trainingLoadChangePercent': _trainingLoadChangePercent,
    'totalTrainingLoad': _totalTrainingLoad,
    'createdAt': _createdAt?.format(),
    'updatedAt': _updatedAt?.format(),
  };

  Map<String, Object?> toMap() => {
    'id': id,
    'routineExerciseId': _routineExerciseId,
    'date': _date,
    'notes': _notes,
    'trainingLoadChangePercent': _trainingLoadChangePercent,
    'totalTrainingLoad': _totalTrainingLoad,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
  };

  static final amplify_core.QueryModelIdentifier<WorkoutLogModelIdentifier>
  MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<WorkoutLogModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ROUTINEEXERCISEID = amplify_core.QueryField(
    fieldName: "routineExerciseId",
  );
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final NOTES = amplify_core.QueryField(fieldName: "notes");
  static final TRAININGLOADCHANGEPERCENT = amplify_core.QueryField(
    fieldName: "trainingLoadChangePercent",
  );
  static final TOTALTRAININGLOAD = amplify_core.QueryField(
    fieldName: "totalTrainingLoad",
  );
  static var schema = amplify_core.Model.defineSchema(
    define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
      modelSchemaDefinition.name = "WorkoutLog";
      modelSchemaDefinition.pluralName = "WorkoutLogs";

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: WorkoutLog.ROUTINEEXERCISEID,
          isRequired: true,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: WorkoutLog.DATE,
          isRequired: true,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: WorkoutLog.NOTES,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: WorkoutLog.TRAININGLOADCHANGEPERCENT,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: WorkoutLog.TOTALTRAININGLOAD,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
          fieldName: 'createdAt',
          isRequired: false,
          isReadOnly: true,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
          fieldName: 'updatedAt',
          isRequired: false,
          isReadOnly: true,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime,
          ),
        ),
      );
    },
  );
}

class _WorkoutLogModelType extends amplify_core.ModelType<WorkoutLog> {
  const _WorkoutLogModelType();

  @override
  WorkoutLog fromJson(Map<String, dynamic> jsonData) {
    return WorkoutLog.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'WorkoutLog';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [WorkoutLog] in your schema.
 */
class WorkoutLogModelIdentifier
    implements amplify_core.ModelIdentifier<WorkoutLog> {
  final String id;

  /** Create an instance of WorkoutLogModelIdentifier using [id] the primary key. */
  const WorkoutLogModelIdentifier({required this.id});

  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{'id': id});

  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap().entries
      .map((entry) => (<String, dynamic>{entry.key: entry.value}))
      .toList();

  @override
  String serializeAsString() => serializeAsMap().values.join('#');

  @override
  String toString() => 'WorkoutLogModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is WorkoutLogModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
