import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<String?> readToken() => _storage.read(key: StorageKeys.authToken);
  Future<void> saveToken(String token) =>
      _storage.write(key: StorageKeys.authToken, value: token);
  Future<void> clearToken() => _storage.delete(key: StorageKeys.authToken);
}

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());
