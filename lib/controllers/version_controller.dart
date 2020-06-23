import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

class VersionController with ChangeNotifier {
  PackageInfo _info;
  PackageInfo get info => _info;

  VersionController(this._info);

  bool _updateAvailable;
  bool get updateAvailable => _updateAvailable;

  Future<void> checkForUpdates() async {
    _updateAvailable = false;
    notifyListeners();
  }
}
