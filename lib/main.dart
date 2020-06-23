import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './app.dart';
import './locator.dart';
import './services/player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PlayerControl.start();
  final _prefs = await SharedPreferences.getInstance();
  final _info = await PackageInfo.fromPlatform();
  setupLocator();
  runApp(App(_prefs, _info));
}
