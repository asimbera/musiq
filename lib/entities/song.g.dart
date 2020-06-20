// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongEntity _$SongEntityFromJson(Map<String, dynamic> json) {
  return SongEntity(
    (json['songs'] as List)
        ?.map(
            (e) => e == null ? null : Song.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SongEntityToJson(SongEntity instance) =>
    <String, dynamic>{
      'songs': instance.songs,
    };

Song _$SongFromJson(Map<String, dynamic> json) {
  return Song(
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
    json['list'] as String,
    json['more_info'] == null
        ? null
        : MoreInfo.fromJson(json['more_info'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
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
      'more_info': instance.moreInfo,
    };

MoreInfo _$MoreInfoFromJson(Map<String, dynamic> json) {
  return MoreInfo(
    json['music'] as String,
    json['album_id'] as String,
    json['album'] as String,
    json['label'] as String,
    json['origin'] as String,
    json['320kbps'] as String,
    json['encrypted_media_url'] as String,
    json['encrypted_cache_url'] as String,
    json['album_url'] as String,
    json['duration'] as String,
    json['cache_state'] as String,
    json['has_lyrics'] as String,
    json['lyrics_snippet'] as String,
    json['starred'] as String,
    json['copyright_text'] as String,
    json['release_date'] as String,
    json['vcode'] as String,
    json['vlink'] as String,
    json['lyrics_id'] as String,
    json['artistMap'] == null
        ? null
        : ArtistMapEntity.fromJson(json['artistMap'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MoreInfoToJson(MoreInfo instance) => <String, dynamic>{
      'music': instance.music,
      'album_id': instance.albumId,
      'album': instance.album,
      'label': instance.label,
      'origin': instance.origin,
      '320kbps': instance.highQuality,
      'encrypted_media_url': instance.encryptedMediaUrl,
      'encrypted_cache_url': instance.encryptedCacheUrl,
      'album_url': instance.albumUrl,
      'duration': instance.duration,
      'cache_state': instance.cacheState,
      'has_lyrics': instance.hasLyrics,
      'lyrics_snippet': instance.lyricsSnippet,
      'starred': instance.starred,
      'copyright_text': instance.copyrightText,
      'release_date': instance.releaseDate,
      'vcode': instance.vcode,
      'vlink': instance.vlink,
      'lyrics_id': instance.lyricsId,
      'artistMap': instance.artistMap,
    };

ArtistMapEntity _$ArtistMapEntityFromJson(Map<String, dynamic> json) {
  return ArtistMapEntity(
    (json['primary_artists'] as List)
        ?.map((e) => e == null
            ? null
            : MiniArtistEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['featured_artists'] as List)
        ?.map((e) => e == null
            ? null
            : MiniArtistEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['artists'] as List)
        ?.map((e) => e == null
            ? null
            : MiniArtistEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ArtistMapEntityToJson(ArtistMapEntity instance) =>
    <String, dynamic>{
      'primary_artists': instance.primaryArtists,
      'featured_artists': instance.featuredArtists,
      'artists': instance.artists,
    };

MiniArtistEntity _$MiniArtistEntityFromJson(Map<String, dynamic> json) {
  return MiniArtistEntity(
    json['id'] as String,
    json['name'] as String,
    json['role'] as String,
    json['image'] as String,
    json['type'] as String,
    json['perma_url'] as String,
  );
}

Map<String, dynamic> _$MiniArtistEntityToJson(MiniArtistEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'image': instance.image,
      'type': instance.type,
      'perma_url': instance.permaUrl,
    };
