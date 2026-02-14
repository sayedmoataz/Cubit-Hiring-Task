import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/local_storage/config/box_names.dart';
import '../../services/local_storage/contracts/hive_consumer.dart';
import '../../services/local_storage/factory/hive_service_factory.dart';
import '../../services/local_storage/utils/encryption_helper.dart';

final sl = GetIt.instance;

/// Initialize Hive local storage service with encryption.
Future<void> initLocalStorage() async {
  try {
    // Get storage path
    final appDocDir = await getApplicationDocumentsDirectory();
    final storagePath = '${appDocDir.path}/hive_storage';

    debugPrint('[LocalStorage] Initializing Hive...');
    debugPrint('[LocalStorage] Storage path: $storagePath');

    // Get or create encryption key (SECURITY CRITICAL!)
    final encryptionKey = await EncryptionHelper.getOrCreateEncryptionKey();

    // Validate encryption key
    if (!EncryptionHelper.validateKey(encryptionKey)) {
      throw Exception('Invalid encryption key length: ${encryptionKey.length}');
    }

    debugPrint('[LocalStorage] Encryption key loaded ✅');

    // Create Hive consumer with encryption
    final hiveConsumer = await HiveServiceFactory.create(
      storagePath: storagePath,
      encryptionKey: encryptionKey,
        adapters: [],
      boxesToPreload: BoxNames.preloadBoxes,
    );

    // Register as lazy singleton
    sl.registerLazySingleton<HiveConsumer>(() => hiveConsumer);

    debugPrint('[LocalStorage] ✅ Initialized successfully');
    debugPrint('[LocalStorage] Preloaded boxes: ${BoxNames.preloadBoxes}');
    debugPrint('[LocalStorage] Encrypted boxes: ${BoxNames.encryptedBoxes}');
  } catch (e, stackTrace) {
    debugPrint('[LocalStorage] ❌ Initialization failed: $e');
    debugPrint('[LocalStorage] StackTrace: $stackTrace');
    rethrow;
  }
}

/// Clear all user-specific data (use on logout)
Future<void> clearUserData() async {
  try {
    final hiveConsumer = sl<HiveConsumer>();

    debugPrint('[LocalStorage] Clearing user-specific data...');

    for (var boxName in BoxNames.userSpecificBoxes) {
      final result = await hiveConsumer.clearBox(boxName: boxName);
      result.fold(
        (failure) =>
            debugPrint('[LocalStorage] Failed to clear $boxName: $failure'),
        (_) => debugPrint('[LocalStorage] Cleared $boxName ✅'),
      );
    }

    debugPrint('[LocalStorage] User data cleared ✅');
  } catch (e) {
    debugPrint('[LocalStorage] Failed to clear user data: $e');
    rethrow;
  }
}

/// Clear cache data (use for freeing space)
Future<void> clearCacheData() async {
  try {
    final hiveConsumer = sl<HiveConsumer>();

    debugPrint('[LocalStorage] Clearing cache data...');

    for (var boxName in BoxNames.cacheBoxes) {
      final result = await hiveConsumer.clearBox(boxName: boxName);
      result.fold(
        (failure) =>
            debugPrint('[LocalStorage] Failed to clear $boxName: $failure'),
        (_) => debugPrint('[LocalStorage] Cleared $boxName ✅'),
      );
    }

    debugPrint('[LocalStorage] Cache data cleared ✅');
  } catch (e) {
    debugPrint('[LocalStorage] Failed to clear cache data: $e');
    rethrow;
  }
}

/// Complete reset (use for app reset or factory reset)
Future<void> resetLocalStorage() async {
  try {
    debugPrint('[LocalStorage] Performing complete reset...');

    // Close all boxes
    final hiveConsumer = sl<HiveConsumer>();
    await hiveConsumer.closeAllBoxes();

    // Reset encryption (deletes key + closes boxes)
    await EncryptionHelper.resetEncryption();

    debugPrint('[LocalStorage] Complete reset done ⚠️');
  } catch (e) {
    debugPrint('[LocalStorage] Failed to reset: $e');
    rethrow;
  }
}

/// Get storage statistics (for debugging/monitoring)
Future<Map<String, dynamic>> getStorageStats() async {
  try {
    final hiveConsumer = sl<HiveConsumer>();
    final stats = <String, dynamic>{};

    for (var boxName in BoxNames.allBoxNames) {
      final lengthResult = await hiveConsumer.getBoxLength(boxName: boxName);
      lengthResult.fold(
        (_) => stats[boxName] = 'Error',
        (length) => stats[boxName] = length,
      );
    }

    return stats;
  } catch (e) {
    debugPrint('[LocalStorage] Failed to get stats: $e');
    return {};
  }
}
