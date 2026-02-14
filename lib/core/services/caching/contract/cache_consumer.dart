abstract class CacheConsumer {
  // Generic read/write operations
  Future<void> write<T>(String key, T value);
  Future<T?> read<T>(String key);

  // Bulk operations
  Future<void> delete(String key);
  Future<void> clear();
}
