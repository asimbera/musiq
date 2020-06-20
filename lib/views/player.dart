import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import './common.dart';
import '../services/player.dart';

class Player extends StatelessWidget {
  const Player({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: buildBackButton(context),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<PlayerStateStream>(
        stream: PlayerControl.playerStateStream,
        builder: (_, snapshot) {
          final _stream = snapshot.data;
          var _mediaItem = _stream?.mediaItem;
          var _state = _stream?.playbackState;
          var _playing = _state?.playing ?? false;
          var _duration = _mediaItem?.duration ?? Duration(seconds: 0);

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(_mediaItem.artUri)),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Album Art
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: CachedNetworkImage(
                          height: _screen.width * 3 / 4,
                          width: _screen.width * 3 / 4,
                          imageUrl: _mediaItem.artUri,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[700].withBlue(100).withOpacity(0.5),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Title, Artists & Like Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Title & Artists
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _mediaItem?.title ?? 'Song Title',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  _mediaItem?.artist ?? 'Artists',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite),
                              iconSize: 30,
                              color: Colors.white.withOpacity(0.6),
                              onPressed: () => null,
                            )
                          ],
                        ),
                        // Seek Bar
                        _SeekBar(duration: _duration),
                        // Control Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.repeat),
                              color: Colors.white,
                              onPressed: null,
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_previous),
                              iconSize: 40,
                              color: Colors.white,
                              onPressed: () => PlayerControl.skipToPrevious(),
                            ),
                            IconButton(
                              icon: Icon(
                                _playing
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                              ),
                              iconSize: 60,
                              color: Colors.white,
                              onPressed: () => _playing
                                  ? PlayerControl.pause()
                                  : PlayerControl.play(),
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next),
                              iconSize: 40,
                              color: Colors.white,
                              onPressed: () => PlayerControl.skipToNext(),
                            ),
                            IconButton(
                              icon: Icon(Icons.shuffle),
                              color: Colors.white,
                              onPressed: null,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SeekBar extends StatefulWidget {
  const _SeekBar({
    Key key,
    // @required Duration position,
    @required Duration duration,
  })  : _duration = duration,
        // _position = position,
        super(key: key);

  // final Duration _position;
  final Duration _duration;

  @override
  __SeekBarState createState() => __SeekBarState();
}

class __SeekBarState extends State<_SeekBar> {
  double _seekPos;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
        stream: PlayerControl.positionStream,
        builder: (_, snapshot) {
          final _position = snapshot.data ?? Duration(milliseconds: 0);
          return Column(
            children: <Widget>[
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.white60,
                  inactiveTrackColor: Colors.white,
                  trackHeight: 3,
                  trackShape: CustomTrackShape(),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 5.0,
                  ),
                ),
                child: Slider(
                  value: _seekPos ??
                      max(
                        0.0,
                        min(
                          _position.inMilliseconds.toDouble(),
                          widget._duration.inMilliseconds.toDouble(),
                        ),
                      ),
                  min: 0.0,
                  max: widget._duration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    setState(() => _seekPos = value);
                  },
                  onChangeEnd: (value) async {
                    await PlayerControl.seekTo(
                      Duration(milliseconds: value.toInt()),
                    );
                    setState(() => _seekPos = null);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    tryParseDuration(_position),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    tryParseDuration(widget._duration),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
