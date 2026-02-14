import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../services/caching/implementation/secure_storage_consumer.dart';
import '../../services/caching/managers/app_prefs_manager.dart';
import '../../services/caching/managers/cache_manager.dart';
import '../../services/performance/performance_service.dart';
import '../injection_container.dart';

Future<void> setupCaching() async {
  PerformanceService.instance.startOperation('Cache Init');

  // Initialize FlutterSecureStorage with Android options
  const secureStorageOptions = AndroidOptions(encryptedSharedPreferences: true);
  const secureStorage = FlutterSecureStorage(aOptions: secureStorageOptions);

  // Create cache consumers
  final secureStorageConsumer = SecureStorageConsumer(secureStorage);

  // Create cache manager
  final cacheManager = CacheManager(
    secureStorage: secureStorageConsumer,
  );

  // Create app preferences manager
  final appPrefsManager = AppPrefsManager(cacheManager);

  // Register in DI
  sl.registerLazySingleton<CacheManager>(() => cacheManager);
  sl.registerLazySingleton<AppPrefsManager>(() => appPrefsManager);
  PerformanceService.instance.endOperation('Cache Init');
}
