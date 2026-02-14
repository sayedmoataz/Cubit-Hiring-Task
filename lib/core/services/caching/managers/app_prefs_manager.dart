import '../cache_keys.dart';
import 'cache_manager.dart';

class AppPrefsManager {
  final CacheManager _cache;

  AppPrefsManager(this._cache);

  Future<void> setToken(String token) async {
    await _cache.writeSecure(CacheKeys.token, token);
  }

  Future<String?> getToken() async {
    return await _cache.readSecure(CacheKeys.token);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await _cache.writeSecure(CacheKeys.refreshToken, refreshToken);
  }

  Future<void> clearUserData() async {
    await _cache.clearSecureStorage();
  }
}
