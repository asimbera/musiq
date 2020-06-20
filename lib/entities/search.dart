import 'package:json_annotation/json_annotation.dart';

part 'search.g.dart';

@JsonSerializable()
class SearchSuggestionItemEntity {
  final String id;
  final String title;
  final String image;
  final String url;
  final String type;
  final String description;

  SearchSuggestionItemEntity(
    this.id,
    this.title,
    this.image,
    this.url,
    this.type,
    this.description,
  );
  factory SearchSuggestionItemEntity.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionItemEntityFromJson(json);
  Map<String, dynamic> toJson() => _$SearchSuggestionItemEntityToJson(this);
}

@JsonSerializable()
class SearchSuggestionEntity {
  final SearchSuggestionDataEntity album;
  final SearchSuggestionDataEntity songs;
  final SearchSuggestionDataEntity artists;
  final SearchSuggestionDataEntity playlists;

  SearchSuggestionEntity(
    this.album,
    this.songs,
    this.artists,
    this.playlists,
  );

  factory SearchSuggestionEntity.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionEntityFromJson(json);
  Map<String, dynamic> toJson() => _$SearchSuggestionEntityToJson(this);
}

@JsonSerializable()
class SearchSuggestionDataEntity {
  final List<SearchSuggestionItemEntity> data;
  final int position;

  SearchSuggestionDataEntity(
    this.data,
    this.position,
  );

  factory SearchSuggestionDataEntity.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionDataEntityFromJson(json);
  Map<String, dynamic> toJson() => _$SearchSuggestionDataEntityToJson(this);
}
