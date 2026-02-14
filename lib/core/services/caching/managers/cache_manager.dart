import '../contract/cache_consumer.dart';

class CacheManager {
  final CacheConsumer secureStorage;

  CacheManager({
    required this.secureStorage,
  });


  /// Write sensitive data (tokens, passwords, etc.)
  Future<void> writeSecure(String key, String value) async {
    await secureStorage.write(key, value);
  }

  /// Read sensitive data
  Future<String?> readSecure(String key) async {
    return await secureStorage.read<String>(key);
  }

  /// Delete sensitive data
  Future<void> deleteSecure(String key) async {
    await secureStorage.delete(key);
  }


  /// Clear all sensitive data
  Future<void> clearSecureStorage() async {
    await secureStorage.clear();
  }

  /// Clear everything (both secure and non-secure)
  Future<void> clearAll() async {
    await secureStorage.clear();
  }
}
