// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchSuggestionItemEntity _$SearchSuggestionItemEntityFromJson(
    Map<String, dynamic> json) {
  return SearchSuggestionItemEntity(
    json['id'] as String,
    json['title'] as String,
    json['image'] as String,
    json['url'] as String,
    json['type'] as String,
    json['description'] as String,
  );
}

Map<String, dynamic> _$SearchSuggestionItemEntityToJson(
        SearchSuggestionItemEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'url': instance.url,
      'type': instance.type,
      'description': instance.description,
    };

SearchSuggestionEntity _$SearchSuggestionEntityFromJson(
    Map<String, dynamic> json) {
  return SearchSuggestionEntity(
    json['album'] == null
        ? null
        : SearchSuggestionDataEntity.fromJson(
            json['album'] as Map<String, dynamic>),
    json['songs'] == null
        ? null
        : SearchSuggestionDataEntity.fromJson(
            json['songs'] as Map<String, dynamic>),
    json['artists'] == null
        ? null
        : SearchSuggestionDataEntity.fromJson(
            json['artists'] as Map<String, dynamic>),
    json['playlists'] == null
        ? null
        : SearchSuggestionDataEntity.fromJson(
            json['playlists'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SearchSuggestionEntityToJson(
        SearchSuggestionEntity instance) =>
    <String, dynamic>{
      'album': instance.album,
      'songs': instance.songs,
      'artists': instance.artists,
      'playlists': instance.playlists,
    };

SearchSuggestionDataEntity _$SearchSuggestionDataEntityFromJson(
    Map<String, dynamic> json) {
  return SearchSuggestionDataEntity(
    (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : SearchSuggestionItemEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['position'] as int,
  );
}

Map<String, dynamic> _$SearchSuggestionDataEntityToJson(
        SearchSuggestionDataEntity instance) =>
    <String, dynamic>{
      'data': instance.data,
      'position': instance.position,
    };
