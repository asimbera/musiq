import 'package:json_annotation/json_annotation.dart';

import './song.dart';

part 'album.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AlbumEntity {
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
  final List<Song> list;

  AlbumEntity(
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
  );

  factory AlbumEntity.fromJson(Map<String, dynamic> json) =>
      _$AlbumEntityFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumEntityToJson(this);
}
