import 'package:flutter/material.dart';

class ThemeContoller with ChangeNotifier {
  ThemeMode _themeMode;
  ThemeContoller(this._themeMode);

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toogleThemeMode() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }

    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
}
