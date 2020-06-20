// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumEntity _$AlbumEntityFromJson(Map<String, dynamic> json) {
  return AlbumEntity(
    json['id'] as String,
    json['title'] as String,
    json['subtitle'] as String,
    json['type'] as String,
    json['perma_url'] as String,
    json['image'] as String,
    json['language'] as String,
    json['year'] as String,
    json['play_count'] as String,
    json['explicit_content'] as String,
    json['list_count'] as String,
    json['list_type'] as String,
    (json['list'] as List)
        ?.map(
            (e) => e == null ? null : Song.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AlbumEntityToJson(AlbumEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'type': instance.type,
      'perma_url': instance.permaUrl,
      'image': instance.image,
      'language': instance.language,
      'year': instance.year,
      'play_count': instance.playCount,
      'explicit_content': instance.explicitContent,
      'list_count': instance.listCount,
      'list_type': instance.listType,
      'list': instance.list,
    };
