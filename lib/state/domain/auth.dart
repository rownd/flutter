import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Auth {
  Auth({
    this.accessToken,
    this.refreshToken,
  });

  String? accessToken;
  String? refreshToken;

  bool get isAuthenticated => accessToken != null;

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  Map<String, dynamic> toJson() => _$AuthToJson(this);
}
