import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './controllers/startup_controller.dart';
import './locator.dart';
import './services/saavn.dart';
import './styles.dart';
import './views/home.dart';
import './views/player.dart';
import './views/queue.dart';

class Musiq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StartupController>(
          create: (_) => StartupController(
            saavn: sl<Saavn>(),
          )
            ..fetchData()
            ..fetchTopSearches(),
        ),
      ],
      child: _App(),
    );
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioServiceWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Musiq',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: Home(),
        routes: {
          '/player': (_) => Player(),
          '/queue': (_) => Queue(),
        },
      ),
    );
  }
}
