import 'package:json_annotation/json_annotation.dart';

part 'app.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class App {
  App({
    this.id,
    this.name,
    this.description,
    this.icon,
    this.schema,
  });

  String? id;
  String? name;
  String? description;
  String? icon;
  Map<String, AppSchemaField>? schema;

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);

  Map<String, dynamic> toJson() => _$AppToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AppSchemaField {
  AppSchemaField({
    this.displayName,
    this.type,
    this.required,
    this.ownedBy,
    this.encryption,
  });

  String? displayName;
  String? type;
  bool? required;
  String? ownedBy;
  AppSchemaFieldEncryption? encryption;

  factory AppSchemaField.fromJson(Map<String, dynamic> json) =>
      _$AppSchemaFieldFromJson(json);

  Map<String, dynamic> toJson() => _$AppSchemaFieldToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AppSchemaFieldEncryption {
  AppSchemaFieldEncryption({this.state});

  String? state;

  factory AppSchemaFieldEncryption.fromJson(Map<String, dynamic> json) =>
      _$AppSchemaFieldEncryptionFromJson(json);

  Map<String, dynamic> toJson() => _$AppSchemaFieldEncryptionToJson(this);
}
