import 'package:json_annotation/json_annotation.dart';

part 'base.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LaunchDataEntity {
  final String greeting;
  final List<BaseEntity> newTrending;
  final List<BaseEntity> topPlaylists;
  final List<BaseEntity> newAlbums;
  final List<BaseEntity> browseDiscover;
  final List<BaseEntity> charts;
  final List<BaseEntity> radio;
  final List<ArtistRecosEntity> artistRecos;

  LaunchDataEntity(
    this.greeting,
    this.newTrending,
    this.topPlaylists,
    this.newAlbums,
    this.browseDiscover,
    this.charts,
    this.radio,
    this.artistRecos,
  );

  factory LaunchDataEntity.fromJson(Map<String, dynamic> json) =>
      _$LaunchDataEntityFromJson(json);
  Map<String, dynamic> toJson() => _$LaunchDataEntityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BaseEntity {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String permaUrl;
  final String image;

  BaseEntity(
    this.id,
    this.title,
    this.subtitle,
    this.type,
    this.permaUrl,
    this.image,
  );

  factory BaseEntity.fromJson(Map<String, dynamic> json) =>
      _$BaseEntityFromJson(json);
  Map<String, dynamic> toJson() => _$BaseEntityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ArtistRecosEntity {
  final String id;
  final String name;
  final String imageUrl;
  final String type;
  final String permaUrl;
  ArtistRecosEntity(
    this.id,
    this.name,
    this.imageUrl,
    this.type,
    this.permaUrl,
  );
  factory ArtistRecosEntity.fromJson(Map<String, dynamic> json) =>
      _$ArtistRecosEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistRecosEntityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TopSearchEntity {
  final String id;
  final String title;
  final String type;
  final String image;
  final String permaUrl;

  TopSearchEntity(this.id, this.title, this.type, this.image, this.permaUrl);

  factory TopSearchEntity.fromJson(Map<String, dynamic> json) =>
      _$TopSearchEntityFromJson(json);
  Map<String, dynamic> toJson() => _$TopSearchEntityToJson(this);
}
