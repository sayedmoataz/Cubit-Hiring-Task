import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../firebase_options.dart';
import '../network/network_info.dart';
import '../services/performance/performance_service.dart';
import 'blocs_injections.dart';
import 'datasources_injections.dart';
import 'repositories_injections.dart';
import 'services/api_injection.dart';
import 'services/biometric_injection.dart';
import 'services/cache_injection.dart';
import 'services/firebase_injection.dart';
import 'services/local_storage_injection.dart';
import 'usecases_injections.dart';

final sl = GetIt.instance;

/// Initialize essential services before app render
/// These are critical services needed for the app to start
Future<void> initEssentialServices() async {
  PerformanceService.instance.startOperation('Essential Services Init');

  //! Core Services
  sl.registerLazySingleton<PerformanceService>(
    () => PerformanceService.instance,
  );

  //! Network
  sl.registerLazySingleton(InternetConnectionChecker.createInstance);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! Caching
  setupCaching();

  //! Local Storage (Hive)
  await initLocalStorage();

  initNetworking();

  //! DataSources
  initDataSources();

  //! Repositories
  initRepositories();

  //! UseCases
  initUseCases();

  //! BLoCs / Cubits
  initBlocs();

  PerformanceService.instance.endOperation('Essential Services Init');
}

/// Initialize remaining services after app render
/// These can be loaded lazily after the UI is displayed
Future<void> initRemainingServices() async {
  PerformanceService.instance.startOperation('Remaining Services Init');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //! Firebase
  await initFirebase();

  //! Biometric
  await initBiometric();

  PerformanceService.instance.endOperation('Remaining Services Init');
}
