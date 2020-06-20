// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamEntity _$StreamEntityFromJson(Map<String, dynamic> json) {
  return StreamEntity(
    json['auth_url'] as String,
    json['type'] as String,
    json['status'] as String,
  );
}

Map<String, dynamic> _$StreamEntityToJson(StreamEntity instance) =>
    <String, dynamic>{
      'auth_url': instance.authUrl,
      'type': instance.type,
      'status': instance.status,
    };
