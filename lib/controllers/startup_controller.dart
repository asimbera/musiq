import 'package:flutter/foundation.dart';

import '../services/saavn.dart';
import '../entities/entities.dart';

class StartupController with ChangeNotifier {
  final Saavn saavn;
  StartupController({
    @required this.saavn,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LaunchDataEntity _launchData;
  LaunchDataEntity get launchData => _launchData;

  Future fetchData() async {
    _isLoading = true;
    notifyListeners();

    _launchData = await saavn.getLaunchData();
    _isLoading = false;
    notifyListeners();
  }

  bool _isSearchLoading = false;
  bool get isSearchLoading => _isSearchLoading;

  List<TopSearchEntity> _topSearches;
  List<TopSearchEntity> get topSearches => _topSearches;

  Future fetchTopSearches() async {
    _isSearchLoading = true;
    notifyListeners();

    _topSearches = await saavn.getTopSearches();
    _isSearchLoading = false;
    notifyListeners();
  }
}
