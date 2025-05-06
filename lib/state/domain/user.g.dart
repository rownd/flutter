// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      data: json['data'] as Map<String, dynamic>?,
      state: json['state'] as String?,
      authLevel: json['auth_level'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'data': instance.data,
      'state': instance.state,
      'auth_level': instance.authLevel,
    };
