// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaunchDataEntity _$LaunchDataEntityFromJson(Map<String, dynamic> json) {
  return LaunchDataEntity(
    json['greeting'] as String,
    (json['new_trending'] as List)
        ?.map((e) =>
            e == null ? null : BaseEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['top_playlists'] as List)
        ?.map((e) =>
            e == null ? null : BaseEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['new_albums'] as List)
        ?.map((e) =>
            e == null ? null : BaseEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['browse_discover'] as List)
        ?.map((e) =>
            e == null ? null : BaseEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['charts'] as List)
        ?.map((e) =>
            e == null ? null : BaseEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['radio'] as List)
        ?.map((e) =>
            e == null ? null : BaseEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['artist_recos'] as List)
        ?.map((e) => e == null
            ? null
            : ArtistRecosEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LaunchDataEntityToJson(LaunchDataEntity instance) =>
    <String, dynamic>{
      'greeting': instance.greeting,
      'new_trending': instance.newTrending,
      'top_playlists': instance.topPlaylists,
      'new_albums': instance.newAlbums,
      'browse_discover': instance.browseDiscover,
      'charts': instance.charts,
      'radio': instance.radio,
      'artist_recos': instance.artistRecos,
    };

BaseEntity _$BaseEntityFromJson(Map<String, dynamic> json) {
  return BaseEntity(
    json['id'] as String,
    json['title'] as String,
    json['subtitle'] as String,
    json['type'] as String,
    json['perma_url'] as String,
    json['image'] as String,
  );
}

Map<String, dynamic> _$BaseEntityToJson(BaseEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'type': instance.type,
      'perma_url': instance.permaUrl,
      'image': instance.image,
    };

ArtistRecosEntity _$ArtistRecosEntityFromJson(Map<String, dynamic> json) {
  return ArtistRecosEntity(
    json['id'] as String,
    json['name'] as String,
    json['image_url'] as String,
    json['type'] as String,
    json['perma_url'] as String,
  );
}

Map<String, dynamic> _$ArtistRecosEntityToJson(ArtistRecosEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'type': instance.type,
      'perma_url': instance.permaUrl,
    };

TopSearchEntity _$TopSearchEntityFromJson(Map<String, dynamic> json) {
  return TopSearchEntity(
    json['id'] as String,
    json['title'] as String,
    json['type'] as String,
    json['image'] as String,
    json['perma_url'] as String,
  );
}

Map<String, dynamic> _$TopSearchEntityToJson(TopSearchEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'image': instance.image,
      'perma_url': instance.permaUrl,
    };
