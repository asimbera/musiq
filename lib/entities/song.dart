import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

@JsonSerializable()
class SongEntity {
  final List<Song> songs;
  SongEntity(this.songs);

  factory SongEntity.fromJson(Map<String, dynamic> json) =>
      _$SongEntityFromJson(json);
  Map<String, dynamic> toJson() => _$SongEntityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Song {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String permaUrl;
  final String image;
  final String language;
  final String year;
  final String playCount;
  final String explicitContent;
  final String listCount;
  final String listType;
  final String list;
  final MoreInfo moreInfo;
  Song(
    this.id,
    this.title,
    this.subtitle,
    this.type,
    this.permaUrl,
    this.image,
    this.language,
    this.year,
    this.playCount,
    this.explicitContent,
    this.listCount,
    this.listType,
    this.list,
    this.moreInfo,
  );

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
  Map<String, dynamic> toJson() => _$SongToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MoreInfo {
  final String music;
  final String albumId;
  final String album;
  final String label;
  final String origin;
  @JsonKey(name: '320kbps')
  final String highQuality;
  final String encryptedMediaUrl;
  final String encryptedCacheUrl;
  final String albumUrl;
  final String duration;
  final String cacheState;
  final String hasLyrics;
  final String lyricsSnippet;
  final String starred;
  final String copyrightText;
  final String releaseDate;
  final String vcode;
  final String vlink;
  final String lyricsId;
  @JsonKey(name: 'artistMap')
  final ArtistMapEntity artistMap;
  MoreInfo(
    this.music,
    this.albumId,
    this.album,
    this.label,
    this.origin,
    this.highQuality,
    this.encryptedMediaUrl,
    this.encryptedCacheUrl,
    this.albumUrl,
    this.duration,
    this.cacheState,
    this.hasLyrics,
    this.lyricsSnippet,
    this.starred,
    this.copyrightText,
    this.releaseDate,
    this.vcode,
    this.vlink,
    this.lyricsId,
    this.artistMap,
  );

  factory MoreInfo.fromJson(Map<String, dynamic> json) =>
      _$MoreInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MoreInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ArtistMapEntity {
  final List<MiniArtistEntity> primaryArtists;
  final List<MiniArtistEntity> featuredArtists;
  final List<MiniArtistEntity> artists;

  ArtistMapEntity(this.primaryArtists, this.featuredArtists, this.artists);

  factory ArtistMapEntity.fromJson(Map<String, dynamic> json) =>
      _$ArtistMapEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistMapEntityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MiniArtistEntity {
  final String id;
  final String name;
  final String role;
  final String image;
  final String type;
  final String permaUrl;

  MiniArtistEntity(
      this.id, this.name, this.role, this.image, this.type, this.permaUrl);

  factory MiniArtistEntity.fromJson(Map<String, dynamic> json) =>
      _$MiniArtistEntityFromJson(json);
  Map<String, dynamic> toJson() => _$MiniArtistEntityToJson(this);
}
