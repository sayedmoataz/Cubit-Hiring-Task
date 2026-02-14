import '../utils/encryption_helper.dart';

/// Configuration for encryption
class EncryptionConfig {
  final List<int> key;

  const EncryptionConfig({required this.key});
  static Future<List<int>> generateKey() async {
    return await EncryptionHelper.getOrCreateEncryptionKey();
  }

  void validate() {
    if (key.length != 32) {
      throw ArgumentError(
        'Encryption key must be exactly 32 bytes long, got ${key.length}',
      );
    }
  }
}