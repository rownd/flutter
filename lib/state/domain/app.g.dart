// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

App _$AppFromJson(Map<String, dynamic> json) => App(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      schema: (json['schema'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, AppSchemaField.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$AppToJson(App instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'schema': instance.schema?.map((k, e) => MapEntry(k, e.toJson())),
    };

AppSchemaField _$AppSchemaFieldFromJson(Map<String, dynamic> json) =>
    AppSchemaField(
      displayName: json['display_name'] as String?,
      type: json['type'] as String?,
      required: json['required'] as bool?,
      ownedBy: json['owned_by'] as String?,
      encryption: json['encryption'] == null
          ? null
          : AppSchemaFieldEncryption.fromJson(
              json['encryption'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppSchemaFieldToJson(AppSchemaField instance) =>
    <String, dynamic>{
      'display_name': instance.displayName,
      'type': instance.type,
      'required': instance.required,
      'owned_by': instance.ownedBy,
      'encryption': instance.encryption?.toJson(),
    };

AppSchemaFieldEncryption _$AppSchemaFieldEncryptionFromJson(
        Map<String, dynamic> json) =>
    AppSchemaFieldEncryption(
      state: json['state'] as String?,
    );

Map<String, dynamic> _$AppSchemaFieldEncryptionToJson(
        AppSchemaFieldEncryption instance) =>
    <String, dynamic>{
      'state': instance.state,
    };
