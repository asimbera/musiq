import 'dart:convert';

import 'package:dio/dio.dart';

import '../entities/entities.dart';

enum ContentLanguage { hindi, english, bengali }

class Saavn {
  final Dio _dio;
  Saavn({
    Dio dio,
    BaseOptions options,
  }) : _dio = dio ??
            Dio(
              options ??
                  BaseOptions(
                    baseUrl: 'https://www.jiosaavn.com/',
                  ),
            );

  Future<SongEntity> getSong(String token) async {
    try {
      final _res = await _dio.get(
        '/api.php',
        queryParameters: {
          "__call": "webapi.get",
          "token": token,
          'type': 'song',
          "includeMetaTags": "0",
          "ctx": "web6dot0",
          "api_version": "4",
          "_format": "json",
          "_marker": "0",
        },
      );
      final _data = SongEntity.fromJson(jsonDecode(_res.data));
      return _data;
    } on DioError {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Song>> getSongReco(String pid) async {
    try {
      final _res = await _dio.get(
        '/api.php',
        queryParameters: {
          "__call": "reco.getreco",
          "ctx": "web6dot0",
          "api_version": "4",
          "_format": "json",
          "_marker": "0",
          "pid": pid
        },
      );
      final _decoded = jsonDecode(_res.data) as List;
      final _data = _decoded.map((e) => Song.fromJson(e)).toList();
      return _data;
    } on DioError {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<AlbumEntity> getAlbum(String token) async {
    try {
      final _res = await _dio.get(
        '/api.php',
        queryParameters: {
          "__call": "webapi.get",
          "token": token,
          "type": "album",
          "includeMetaTags": "0",
          "ctx": "web6dot0",
          "api_version": "4",
          "_format": "json",
          "_marker": "0",
        },
      );
      final _data = AlbumEntity.fromJson(jsonDecode(_res.data));
      return _data;
    } on DioError {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<BaseEntity>> getAlbumReco(String albumid) async {
    try {
      final _res = await _dio.get(
        '/api.php',
        queryParameters: {
          "__call": "reco.getAlbumReco",
          "api_version": "4",
          "_format": "json",
          "_marker": "0",
          "ctx": "web6dot0",
          "albumid": albumid,
        },
      );
      final _decoded = jsonDecode(_res.data) as List;
      final _data = _decoded.map((e) => BaseEntity.fromJson(e)).toList();
      return _data;
    } on DioError {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<TopSearchEntity>> getTopSearches() async {
    try {
      final _res = await _dio.get(
        '/api.php',
        queryParameters: {
          "__call": "content.getTopSearches",
          "ctx": "web6dot0",
          "api_version": "4",
          "_format": "json",
          "_marker": "0",
        },
      );
      final _decoded = jsonDecode(_res.data);
      final _data = List<Map<String, dynamic>>.from(_decoded)
          .map((e) => TopSearchEntity.fromJson(e))
          .toList();
      return _data;
    } on DioError {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<SearchSuggestionEntity> getAutocomplete(String query) async {
    try {
      final _res = await _dio.get(
        '/api.php',
        queryParameters: {
          '__call': 'autocomplete.get',
          'query': query,
          '_format': 'json',
          '_marker': '0',
          'ctx': 'web6dot0',
        },
      );
      final _data = SearchSuggestionEntity.fromJson(jsonDecode(_res.data));
      return _data;
    } on DioError {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<PlaylistEntity> getPlaylist(
    String token, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final _res = await _dio.get(
        '/api.php',
        queryParameters: {
          "__call": "webapi.get",
          "token": token,
          "type": "playlist",
          "p": page,
          "n": limit,
          "includeMetaTags": "0",
          "ctx": "web6dot0",
          "api_version": "4",
          "_format": "json",
          "_marker": "0",
        },
      );
      final _data = PlaylistEntity.fromJson(jsonDecode(_res.data));
      return _data;
    } on DioError {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<LaunchDataEntity> getLaunchData({
    List<ContentLanguage> lang = const [
      ContentLanguage.hindi,
      ContentLanguage.english
    ],
  }) async {
    try {
      List<String> _langCodes =
          lang.map((e) => e.toString().split('.').last).toList();
      final _res = await _dio.get(
        '/api.php',
        queryParameters: {
          "__call": "webapi.getLaunchData",
          "api_version": "4",
          "_format": "json",
          "_marker": "0",
          "ctx": "web6dot0",
          "app_version": "4",
        },
        options: Options(
          headers: {'Cookie': 'L=${_langCodes.join(',')}'},
        ),
      );
      final _data = LaunchDataEntity.fromJson(jsonDecode(_res.data));
      return _data;
    } on DioError {
      print('getLaunchData | DioError');
      return null;
    } catch (e) {
      print('getLaunchData | ${e.toString()}');
      return null;
    }
  }

  static Future<StreamEntity> getStream(
    String url, {
    int bitrate = 128,
  }) async {
    final Dio _d = Dio(
      BaseOptions(
        baseUrl: 'https://www.jiosaavn.com/',
      ),
    );
    try {
      final _res = await _d.get(
        '/api.php',
        queryParameters: {
          "__call": "song.generateAuthToken",
          "url": url,
          "bitrate": bitrate,
          "api_version": "4",
          "_format": "json",
          "ctx": "web6dot0",
          "_marker": '0',
        },
      );
      final _data = StreamEntity.fromJson(jsonDecode(_res.data));
      return _data;
    } on DioError {
      return null;
    } catch (e) {
      return null;
    }
  }
}
