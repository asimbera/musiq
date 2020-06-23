import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../services/player.dart';

class SharedDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Container(),
          ),
          _buildDrawerAction(
            context: context,
            title: 'Home',
            icon: Icons.home,
            target: '/',
          ),
          _buildDrawerAction(
            context: context,
            title: 'Radio',
            icon: Icons.radio,
            target: '/radio',
            enabled: false,
          ),
          _buildDrawerAction(
            context: context,
            title: 'Library',
            icon: Icons.library_music,
            target: '/library',
            enabled: false,
          ),
          Divider(),
          _buildDrawerAction(
            context: context,
            title: 'Settings',
            icon: Icons.settings_applications,
            target: '/settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerAction({
    @required BuildContext context,
    @required String title,
    @required IconData icon,
    @required String target,
    bool enabled = true,
  }) {
    final isCurrent = ModalRoute.of(context).settings.name == target;
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      selected: isCurrent,
      enabled: enabled,
      onTap: () {
        Navigator.of(context).pop();
        if (!isCurrent) Navigator.pushNamed(context, target);
      },
    );
  }
}

class BottomPlayerBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerStateStream>(
      stream: PlayerControl.playerStateStream,
      builder: (_, snapshot) {
        final _data = snapshot?.data;
        final _state = _data?.playbackState;
        final _mediaItem = _data?.mediaItem;
        final _playing = _state?.playing ?? false;
        final _processingState =
            _state?.processingState ?? AudioProcessingState.none;
        final _position = _state?.position?.inMilliseconds ?? 0;
        final _duration = _mediaItem?.duration?.inMilliseconds ?? 1;
        print(_processingState);
        return _processingState == AudioProcessingState.none
            ? Container(
                height: 0,
                width: 0,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Progress bar
                  SizedBox(
                    height: 2,
                    child: LinearProgressIndicator(
                      value: _position / _duration,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor,
                      ),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // color: Theme.of(context).backgroundColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black12,
                          width: 0.5,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: _mediaItem.artUri,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _mediaItem.title,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  _mediaItem.artist,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_previous),
                          onPressed: () => PlayerControl.skipToPrevious(),
                        ),
                        IconButton(
                          icon: Icon(
                            _playing
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                          ),
                          onPressed: () => _playing
                              ? PlayerControl.pause()
                              : PlayerControl.play(),
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next),
                          onPressed: () => PlayerControl.skipToNext(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }
}

Widget buildShimmerContainer({BuildContext context, Widget child}) {
  return context == null
      ? Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[300],
          // enabled: false,
          child: child,
        )
      : Shimmer.fromColors(
          child: child,
          baseColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]
              : Colors.grey[700],
          highlightColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[300]
              : Colors.grey[600],
        );
}

Widget buildListItem({
  @required BuildContext context,
  Widget leading,
  @required String title,
  @required String subtitle,
  Widget trailing,
  VoidCallback onPress,
  EdgeInsetsGeometry margin,
  EdgeInsetsGeometry padding,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      margin: margin ??
          EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[200]
            : Colors.grey[700].withBlue(100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          leading ?? Container(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  )
                ],
              ),
            ),
          ),
          trailing ?? Container(),
        ],
      ),
    ),
  );
}

String prependZero(int _num) {
  return _num < 10 ? '0$_num' : _num.toString();
}

String tryParseDuration(Duration duration) {
  var _totalSeconds = duration?.inSeconds ?? Duration(seconds: 0).inSeconds;
  var _seconds = _totalSeconds.remainder(60);
  var _minutes = (_totalSeconds / 60).floor();
  var _hours = (_minutes / 60).floor();
  if (_hours > 0) {
    return '$_hours : $_minutes : $_seconds';
  } else if (_minutes > 0) {
    return '${prependZero(_minutes)} : ${prependZero(_seconds)}';
  } else {
    return '00 : ${prependZero(_seconds)}';
  }
}

String toTitleCase(String str) {
  return str
      .replaceAllMapped(
          RegExp(
              r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
          (Match m) =>
              "${m[0][0].toUpperCase()}${m[0].substring(1).toLowerCase()}")
      .replaceAll(RegExp(r'(_|-)+'), ' ');
}
