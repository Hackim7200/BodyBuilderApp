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

// NOTE: Synced with amplify/backend/api/bodybuildingapp/schema.graphql (Circuit type).

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;

/** Represents the Circuit type in your schema. */
class Circuit extends amplify_core.Model {
  static const classType = const _CircuitModelType();
  final String id;
  final String? _name;
  final String? _description;
  final int? _rounds;
  final int? _stationDurationSeconds;
  final int? _preStartCountdownSeconds;
  final int? _restBetweenRoundsSeconds;
  final bool? _randomizeStationOrder;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
    '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.',
  )
  @override
  String getId() => id;

  CircuitModelIdentifier get modelIdentifier {
    return CircuitModelIdentifier(id: id);
  }

  String get name {
    try {
      return _name!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
        amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
        recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
        underlyingException: e.toString(),
      );
    }
  }

  String? get description => _description;

  int? get rounds => _rounds;

  int? get stationDurationSeconds => _stationDurationSeconds;

  int? get preStartCountdownSeconds => _preStartCountdownSeconds;

  int? get restBetweenRoundsSeconds => _restBetweenRoundsSeconds;

  bool? get randomizeStationOrder => _randomizeStationOrder;

  amplify_core.TemporalDateTime? get createdAt => _createdAt;

  amplify_core.TemporalDateTime? get updatedAt => _updatedAt;

  const Circuit._internal({
    required this.id,
    required String name,
    String? description,
    int? rounds,
    int? stationDurationSeconds,
    int? preStartCountdownSeconds,
    int? restBetweenRoundsSeconds,
    bool? randomizeStationOrder,
    amplify_core.TemporalDateTime? createdAt,
    amplify_core.TemporalDateTime? updatedAt,
  })  : _name = name,
        _description = description,
        _rounds = rounds,
        _stationDurationSeconds = stationDurationSeconds,
        _preStartCountdownSeconds = preStartCountdownSeconds,
        _restBetweenRoundsSeconds = restBetweenRoundsSeconds,
        _randomizeStationOrder = randomizeStationOrder,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Circuit({
    String? id,
    required String name,
    String? description,
    int? rounds,
    int? stationDurationSeconds,
    int? preStartCountdownSeconds,
    int? restBetweenRoundsSeconds,
    bool? randomizeStationOrder,
  }) {
    return Circuit._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      description: description,
      rounds: rounds,
      stationDurationSeconds: stationDurationSeconds,
      preStartCountdownSeconds: preStartCountdownSeconds,
      restBetweenRoundsSeconds: restBetweenRoundsSeconds,
      randomizeStationOrder: randomizeStationOrder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Circuit &&
        id == other.id &&
        _name == other._name &&
        _description == other._description &&
        _rounds == other._rounds &&
        _stationDurationSeconds == other._stationDurationSeconds &&
        _preStartCountdownSeconds == other._preStartCountdownSeconds &&
        _restBetweenRoundsSeconds == other._restBetweenRoundsSeconds &&
        _randomizeStationOrder == other._randomizeStationOrder;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('Circuit {');
    buffer.write('id=' + id + ', ');
    buffer.write('name=' + '$_name' + ', ');
    buffer.write('description=' + '$_description' + ', ');
    buffer.write(
      'rounds=' +
          (_rounds != null ? _rounds.toString() : 'null') +
          ', ',
    );
    buffer.write(
      'stationDurationSeconds=' +
          (_stationDurationSeconds != null
              ? _stationDurationSeconds.toString()
              : 'null') +
          ', ',
    );
    buffer.write(
      'preStartCountdownSeconds=' +
          (_preStartCountdownSeconds != null
              ? _preStartCountdownSeconds.toString()
              : 'null') +
          ', ',
    );
    buffer.write(
      'restBetweenRoundsSeconds=' +
          (_restBetweenRoundsSeconds != null
              ? _restBetweenRoundsSeconds.toString()
              : 'null') +
          ', ',
    );
    buffer.write(
      'randomizeStationOrder=' +
          (_randomizeStationOrder != null
              ? _randomizeStationOrder.toString()
              : 'null') +
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

  Circuit copyWith({
    String? name,
    String? description,
    int? rounds,
    int? stationDurationSeconds,
    int? preStartCountdownSeconds,
    int? restBetweenRoundsSeconds,
    bool? randomizeStationOrder,
  }) {
    return Circuit._internal(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      rounds: rounds ?? this.rounds,
      stationDurationSeconds:
          stationDurationSeconds ?? this.stationDurationSeconds,
      preStartCountdownSeconds:
          preStartCountdownSeconds ?? this.preStartCountdownSeconds,
      restBetweenRoundsSeconds:
          restBetweenRoundsSeconds ?? this.restBetweenRoundsSeconds,
      randomizeStationOrder:
          randomizeStationOrder ?? this.randomizeStationOrder,
    );
  }

  Circuit copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String?>? description,
    ModelFieldValue<int?>? rounds,
    ModelFieldValue<int?>? stationDurationSeconds,
    ModelFieldValue<int?>? preStartCountdownSeconds,
    ModelFieldValue<int?>? restBetweenRoundsSeconds,
    ModelFieldValue<bool?>? randomizeStationOrder,
  }) {
    return Circuit._internal(
      id: id,
      name: name == null ? this.name : name.value,
      description: description == null ? this.description : description.value,
      rounds: rounds == null ? this.rounds : rounds.value,
      stationDurationSeconds: stationDurationSeconds == null
          ? this.stationDurationSeconds
          : stationDurationSeconds.value,
      preStartCountdownSeconds: preStartCountdownSeconds == null
          ? this.preStartCountdownSeconds
          : preStartCountdownSeconds.value,
      restBetweenRoundsSeconds: restBetweenRoundsSeconds == null
          ? this.restBetweenRoundsSeconds
          : restBetweenRoundsSeconds.value,
      randomizeStationOrder: randomizeStationOrder == null
          ? this.randomizeStationOrder
          : randomizeStationOrder.value,
    );
  }

  Circuit.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _name = json['name'],
        _description = json['description'],
        _rounds = (json['rounds'] as num?)?.toInt(),
        _stationDurationSeconds =
            (json['stationDurationSeconds'] as num?)?.toInt(),
        _preStartCountdownSeconds =
            (json['preStartCountdownSeconds'] as num?)?.toInt(),
        _restBetweenRoundsSeconds =
            (json['restBetweenRoundsSeconds'] as num?)?.toInt(),
        _randomizeStationOrder = json['randomizeStationOrder'] as bool?,
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': _name,
        'description': _description,
        'rounds': _rounds,
        'stationDurationSeconds': _stationDurationSeconds,
        'preStartCountdownSeconds': _preStartCountdownSeconds,
        'restBetweenRoundsSeconds': _restBetweenRoundsSeconds,
        'randomizeStationOrder': _randomizeStationOrder,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format(),
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'name': _name,
        'description': _description,
        'rounds': _rounds,
        'stationDurationSeconds': _stationDurationSeconds,
        'preStartCountdownSeconds': _preStartCountdownSeconds,
        'restBetweenRoundsSeconds': _restBetweenRoundsSeconds,
        'randomizeStationOrder': _randomizeStationOrder,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt,
      };

  static final amplify_core.QueryModelIdentifier<CircuitModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<CircuitModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: 'id');
  static final NAME = amplify_core.QueryField(fieldName: 'name');
  static final DESCRIPTION = amplify_core.QueryField(fieldName: 'description');
  static final ROUNDS = amplify_core.QueryField(fieldName: 'rounds');
  static final STATIONDURATIONSECONDS =
      amplify_core.QueryField(fieldName: 'stationDurationSeconds');
  static final PRESTARTCOUNTDOWNSECONDS =
      amplify_core.QueryField(fieldName: 'preStartCountdownSeconds');
  static final RESTBETWEENROUNDSSECONDS =
      amplify_core.QueryField(fieldName: 'restBetweenRoundsSeconds');
  static final RANDOMIZESTATIONORDER =
      amplify_core.QueryField(fieldName: 'randomizeStationOrder');
  static var schema = amplify_core.Model.defineSchema(
    define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
      modelSchemaDefinition.name = 'Circuit';
      modelSchemaDefinition.pluralName = 'Circuits';

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Circuit.NAME,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string),
      ));

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Circuit.DESCRIPTION,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string),
      ));

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Circuit.ROUNDS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int),
      ));

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Circuit.STATIONDURATIONSECONDS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int),
      ));

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Circuit.PRESTARTCOUNTDOWNSECONDS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int),
      ));

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Circuit.RESTBETWEENROUNDSSECONDS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int),
      ));

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Circuit.RANDOMIZESTATIONORDER,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool),
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

class _CircuitModelType extends amplify_core.ModelType<Circuit> {
  const _CircuitModelType();

  @override
  Circuit fromJson(Map<String, dynamic> jsonData) {
    return Circuit.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'Circuit';
  }
}

class CircuitModelIdentifier implements amplify_core.ModelIdentifier<Circuit> {
  final String id;

  const CircuitModelIdentifier({required this.id});

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
  String toString() => 'CircuitModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }

    return other is CircuitModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
