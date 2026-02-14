import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../contract/cache_consumer.dart';

class SecureStorageConsumer implements CacheConsumer {
  final FlutterSecureStorage _storage;

  SecureStorageConsumer(this._storage);

  @override
  Future<void> write<T>(String key, T value) async {
    if (value == null) {
      await delete(key);
      return;
    }

    // All values stored as strings (encrypted by the platform)
    final stringValue = value is String ? value : jsonEncode(value);
    await _storage.write(key: key, value: stringValue);
  }

  @override
  Future<T?> read<T>(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;

    // Handle type conversion
    if (T == String) return value as T;

    // For other types, deserialize from JSON
    try {
      final decoded = jsonDecode(value);
      return decoded as T;
    } catch (e) {
      // If JSON parsing fails, return raw string
      return value as T?;
    }
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
