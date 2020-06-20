import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import './saavn.dart';
import '../entities/song.dart';

MediaControl _playControl = MediaControl(
  androidIcon: 'drawable/ic_play',
  action: MediaAction.play,
  label: 'Play',
);

MediaControl _pauseControl = MediaControl(
  androidIcon: 'drawable/ic_pause',
  action: MediaAction.pause,
  label: 'Pause',
);

MediaControl _skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  action: MediaAction.skipToNext,
  label: 'Next',
);

MediaControl _skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  action: MediaAction.skipToPrevious,
  label: 'Previous',
);

class PlayerTask extends BackgroundAudioTask {
  final _queue = <MediaItem>[];
  AudioPlayer _audioPlayer = AudioPlayer();
  Completer _completer = Completer();
  int _pointer = -1;
  bool _playing;
  AudioProcessingState _skipState;

  bool get hasNext => _pointer + 1 < _queue.length;

  bool get hasPrevious => _pointer > 0;

  MediaItem get mediaItem => _queue[_pointer];

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    final playerStateSubscription = _audioPlayer.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) {
      _handlePlaybackCompleted();
    });

    final eventSubscription = _audioPlayer.playbackEventStream.listen(
      (event) {
        final bufferingState =
            event.buffering ? AudioProcessingState.buffering : null;
        switch (event.state) {
          case AudioPlaybackState.paused:
            _setState(
              processingState: bufferingState ?? AudioProcessingState.ready,
              position: event.position,
            );
            break;
          case AudioPlaybackState.playing:
            _setState(
              processingState: bufferingState ?? AudioProcessingState.ready,
              position: event.position,
            );
            break;
          case AudioPlaybackState.connecting:
            _setState(
              processingState: _skipState ?? AudioProcessingState.connecting,
              position: event.position,
            );
            break;
          default:
            break;
        }
      },
    );

    // AudioServiceBackground.setQueue(_queue);
    // await onSkipToNext();
    await _completer.future;
    // cancel all stream subscriptions
    playerStateSubscription.cancel();
    eventSubscription.cancel();
  }

  void _handlePlaybackCompleted() {
    if (hasNext) {
      onSkipToNext();
    } else {
      _playing = false;
      _audioPlayer.stop();
      _setState(processingState: AudioProcessingState.ready);
    }
  }

  @override
  Future<void> onSkipToNext() async {
    if (_pointer == _queue.length - 1) {
      _skipToBegining();
    } else {
      _skip(1);
    }
  }

  @override
  Future<void> onSkipToPrevious() async {
    if (_pointer == 0) {
      _skipToEnd();
    } else {
      _skip(-1);
    }
  }

  Future<void> _skip([int offset, int to]) async {
    final newPos = to ?? _pointer + offset;
    if (!(newPos >= 0 && newPos < _queue.length)) return;
    if (_playing == null) {
      // First time, we want to start playing
      _playing = true;
    } else if (_playing) {
      // Stop current item
      await _audioPlayer.stop();
    }
    // Load next item
    _pointer = newPos;
    AudioServiceBackground.setMediaItem(mediaItem);
    _skipState = offset > 0
        ? AudioProcessingState.skippingToNext
        : AudioProcessingState.skippingToPrevious;
    final _streamUrl = await Saavn.getStream(mediaItem.extras['token']);
    if (_streamUrl != null) {
      await _audioPlayer.setUrl(_streamUrl.authUrl);
      _skipState = null;
      // Resume or start playback
      onPlay();
    } else {
      onSkipToNext();
    }
  }

  Future<void> _skipToBegining() => _skip(0, 0);
  Future<void> _skipToEnd() => _skip(0, _queue.length - 1);

  void playPause() {
    if (AudioServiceBackground.state.playing) {
      onPause();
    } else {
      onPlay();
    }
  }

  @override
  void onPlay() {
    if (_skipState == null) {
      _playing = true;
      _audioPlayer.play();
    }
  }

  @override
  void onPause() {
    if (_skipState == null) {
      _playing = false;
      _audioPlayer.pause();
      // AudioServiceBackground.sendCustomEvent('just paused');
    }
  }

  @override
  void onSeekTo(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  Future<void> onFastForward() async {
    await _seekRelative(fastForwardInterval);
  }

  @override
  Future<void> onRewind() async {
    await _seekRelative(rewindInterval);
  }

  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _audioPlayer.playbackEvent.position + offset;
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
    await _audioPlayer.seek(_audioPlayer.playbackEvent.position + offset);
  }

  @override
  Future<void> onStop() async {
    // await _audioPlayer.stop();
    // await _audioPlayer.dispose();
    // _playing = false;
    // _setState(processingState: AudioProcessingState.completed);
    // _completer.complete();
    onPause();
  }

  @override
  void onAddQueueItem(MediaItem mediaItem) {
    _queue.add(mediaItem);
    AudioServiceBackground.setQueue(_queue);
  }

  @override
  void onSkipToQueueItem(String mediaId) async {
    final _i = int.tryParse(mediaId);
    await _skip(0, _i);
  }

  @override
  Future onCustomAction(String name, arguments) async {
    switch (name) {
      case 'addQueueItem':
        final _map = arguments;
        final _mediaItem = MediaItem(
            id: _map['id'],
            title: _map['title'],
            album: _map['album'],
            artist: _map['artist'],
            duration: Duration(
              seconds: _map['duration'],
            ),
            artUri: _map['artUri'],
            extras: {
              'token': _map['token'],
            });
        _queue.add(_mediaItem);
        await AudioServiceBackground.setQueue(_queue);
        await onSkipToNext();
        return Future.value(_queue.length);
        break;
      case 'skipToBegining':
        await _skipToBegining();
        break;
      case 'skipToEnd':
        await _skipToEnd();
        break;
      default:
        return Future.value(false);
        break;
    }
  }

  void _setState({
    AudioProcessingState processingState,
    Duration position,
    Duration bufferedPosition,
  }) {
    if (position == null) {
      position = _audioPlayer.playbackEvent.position;
    }
    AudioServiceBackground.setState(
      controls: getControls(),
      systemActions: [MediaAction.seekTo],
      processingState:
          processingState ?? AudioServiceBackground.state.processingState,
      playing: _playing,
      position: position,
      bufferedPosition: bufferedPosition ?? position,
      speed: _audioPlayer.speed,
    );
  }

  List<MediaControl> getControls() {
    if (_playing) {
      return [_skipToPreviousControl, _pauseControl, _skipToNextControl];
    } else {
      return [_skipToPreviousControl, _playControl, _skipToNextControl];
    }
  }
}

class PlayerControl {
  /// checks if isolate is running
  static bool get isRunning => AudioService.running;

  /// Information and controls of isolate
  /// combined into one stream.
  static Stream<PlayerStateStream> get playerStateStream => Rx.combineLatest3<
          List<MediaItem>, MediaItem, PlaybackState, PlayerStateStream>(
        AudioService.queueStream,
        AudioService.currentMediaItemStream,
        AudioService.playbackStateStream,
        (
          queue,
          mediaItem,
          playbackState,
        ) =>
            PlayerStateStream(
          queue,
          mediaItem,
          playbackState,
        ),
      );

  // Temporary storage for drag value.
  static BehaviorSubject<double> get dragPositionSubject =>
      BehaviorSubject.seeded(null);

  static Stream<Duration> get positionStream =>
      Rx.combineLatest2<PlaybackState, double, Duration>(
        AudioService.playbackStateStream,
        Stream.periodic(Duration(milliseconds: 500)),
        (state, _) => state?.currentPosition ?? Duration(milliseconds: 0),
      );

  /// Checks and starts audio_service isolate.
  static Future<void> start() async {
    if (!isRunning)
      await AudioService.start(
        backgroundTaskEntrypoint: taskEntryPoint,
        androidEnableQueue: true,
        androidNotificationChannelName: 'Musiq',
        androidNotificationColor: 0xFF2050AA,
        androidNotificationIcon: 'drawable/ic_music_note',
        androidStopOnRemoveTask: true,
        androidStopForegroundOnPause: true,
      );
  }

  /// Check if isolate is running and
  /// adds [song] to queue.
  static Future<void> enqueue(Song song) async {
    if (!isRunning) await start();
    print('enqueue | ${song.title}');
    final _item = extractMetadata(song);
    AudioService.addQueueItem(_item);
  }

  /// Checks if isolate is running,
  /// adds [song] to queue and starts to play.
  static Future<void> playNow(Song song) async {
    print('playNow | ${song.title}');
    final _item = extractMetadata(song);

    // Checks if the item is already in queue.
    final _queue = AudioService.queue;
    print('playNow | queue.length: ${_queue.length}');
    if (_queue.contains(_item)) {
      final _pointer = _queue.indexOf(_item);
      print('playNow | _pointer: $_pointer');
      await AudioService.skipToQueueItem(_pointer.toString());
    } else {
      await AudioService.addQueueItem(_item);
      await skipToEnd();
    }
  }

  /// Resumes current media.
  static Future<void> play() => AudioService.play();

  /// Pauses current media.
  static Future<void> pause() => AudioService.pause();

  /// Skip to next media.
  static Future<void> skipToNext() => AudioService.skipToNext();

  /// Skip to previous media.
  static Future<void> skipToPrevious() => AudioService.skipToPrevious();

  /// Jumps to the begining of the queue.
  static Future<void> skipToBegining() => AudioService.customAction(
        'skipToBegining',
      );

  /// Jumps to the end of the queue.
  static Future<void> skipToEnd() => AudioService.customAction(
        'skipToEnd',
      );
  static Future<void> seekTo(Duration position) =>
      AudioService.seekTo(position);
}

class PlayerStateStream {
  final List<MediaItem> queue;
  final MediaItem mediaItem;
  final PlaybackState playbackState;

  PlayerStateStream(this.queue, this.mediaItem, this.playbackState);
}

void taskEntryPoint() async {
  AudioServiceBackground.run(() => PlayerTask());
}

MediaItem extractMetadata(Song song) {
  return MediaItem(
    id: song.id,
    title: song.title,
    album: song.moreInfo.album,
    artist: extractArtists(song.moreInfo.artistMap),
    duration: Duration(
      seconds: int.tryParse(song.moreInfo.duration) ?? 0,
    ),
    artUri: song.image,
    extras: {
      'token': song.moreInfo.encryptedMediaUrl,
    },
  );
}

String extractArtists(ArtistMapEntity entity) {
  return entity.primaryArtists.map((e) => e.name).join(", ");
}
