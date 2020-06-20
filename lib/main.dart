import 'dart:async';

import 'package:flutter/material.dart';

import './app.dart';
import './locator.dart';
import './services/sentry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  runZonedGuarded<Future<void>>(() async {
    runApp(Musiq());
  }, (Object error, StackTrace stackTrace) {
    sl<Sentry>().report(error, stackTrace);
  });
}
