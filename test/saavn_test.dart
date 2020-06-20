import 'package:flutter_test/flutter_test.dart';

import 'package:musiq/services/saavn.dart';

void main() {
  group('Saavn', () {
    Saavn _saavn = Saavn();
    test('should match song title', () async {
      final _song = await _saavn.getSong('Bx9dYzlVfAc');
      expect(_song.songs[0].title, 'Bheegi Bheegi');
    });
    test('should return list of songs', () async {
      final _list = await _saavn.getSongReco('a_nqEXwl');
      assert(_list.length != 0);
    });
    test('should match album title', () async {
      final _album = await _saavn.getAlbum('qrpINyGKhwA_');
      expect(_album.title, 'Bheegi Bheegi');
    });
    test('should return list of albums', () async {
      final _list = await _saavn.getAlbumReco('20316543');
      assert(_list.length != 0);
    });
    test('should match playlist title', () async {
      final _playlist = await _saavn.getPlaylist('JIFP3OT7,SmO0eMLZZxqsA__');
      expect(_playlist.title, 'Only Khushiyan');
    });
    test('should parse launch data', () async {
      await _saavn.getLaunchData();
    });
    test('should return list of search', () async {
      final _topSearches = await _saavn.getTopSearches();
      assert(_topSearches.length > 0);
    });
  });
}
