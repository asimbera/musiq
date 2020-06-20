import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildBackButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.chevron_left),
    onPressed: () => Navigator.of(context).pop(),
  );
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

Widget gradientMask({Widget child}) {
  return ShaderMask(
    shaderCallback: (bounds) => LinearGradient(
      colors: [
        Colors.blue,
        Colors.deepPurple,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds),
    child: child,
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
