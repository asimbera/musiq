import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './controllers/config_controller.dart';
import './controllers/startup_controller.dart';
import './controllers/version_controller.dart';
import './locator.dart';
import './services/saavn.dart';
import './styles.dart';
import './views/home.dart';
import './views/search.dart';
import './views/settings.dart';

class App extends StatelessWidget {
  final SharedPreferences _preferences;
  final PackageInfo _info;
  App(this._preferences, this._info);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConfigController>(
          create: (_) => ConfigController(_preferences)..restore(),
        ),
        ChangeNotifierProvider<StartupController>(
          create: (_) => StartupController(
            saavn: sl<Saavn>(),
          )
            ..fetchData()
            ..fetchTopSearches(),
        ),
        ChangeNotifierProvider<VersionController>(
          create: (_) => VersionController(_info),
        ),
      ],
      child: Musiq(),
    );
  }
}

class Musiq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioServiceWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Musiq',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: Provider.of<ConfigController>(context).darkMode
            ? ThemeMode.dark
            : ThemeMode.light,
        home: Home(),
        routes: {
          '/search': (_) => Search(),
          '/settings': (_) => Settings(),
        },
      ),
    );
  }
}
