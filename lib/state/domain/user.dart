import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class User {
  User({this.data, this.state, this.authLevel});

  String? get id => data?['user_id'];
  Map<String, dynamic>? data;
  String? state;
  String? authLevel;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
