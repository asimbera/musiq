import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigController with ChangeNotifier {
  final SharedPreferences _preferences;
  ConfigController(this._preferences);

  bool _darkMode;
  bool get darkMode => _darkMode;

  int _quality;
  int get quality => _quality;

  void restore() {
    _darkMode = _preferences.getBool('dark_mode') ?? false;
    _quality = _preferences.getInt('quality') ?? 128;
    notifyListeners();
  }

  Future<void> toogleDarkMode(bool _val) async {
    await _preferences.setBool('dark_mode', _val);
    _darkMode = _val;
    notifyListeners();
  }

  Future<void> changeQuality(int _val) async {
    await _preferences.setInt('quality', _val);
    _quality = _val;
    notifyListeners();
  }
}
