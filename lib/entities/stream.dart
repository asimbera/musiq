import 'package:json_annotation/json_annotation.dart';

part 'stream.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StreamEntity {
  final String authUrl;
  final String type;
  final String status;
  StreamEntity(this.authUrl, this.type, this.status);

  factory StreamEntity.fromJson(Map<String, dynamic> json) =>
      _$StreamEntityFromJson(json);
  Map<String, dynamic> toJson() => _$StreamEntityToJson(this);
}