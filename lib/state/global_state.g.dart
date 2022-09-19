// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalState _$GlobalStateFromJson(Map<String, dynamic> json) => GlobalState(
      app: json['appConfig'] == null
          ? null
          : App.fromJson(json['appConfig'] as Map<String, dynamic>),
      auth: json['auth'] == null
          ? null
          : Auth.fromJson(json['auth'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GlobalStateToJson(GlobalState instance) =>
    <String, dynamic>{
      'appConfig': instance.app?.toJson(),
      'auth': instance.auth?.toJson(),
    };
