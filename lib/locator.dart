import 'package:get_it/get_it.dart';

import './services/saavn.dart';

GetIt sl = GetIt.I;

void setupLocator() {
  sl.registerLazySingleton<Saavn>(() => Saavn());
}
