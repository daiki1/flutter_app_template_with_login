import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

/// Storage utility service that manages both secure and non-secure storage
/// Secure storage is used for sensitive data like tokens
/// GetStorage is used for non-sensitive data like preferences
class StorageService {
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static final _localStorage = GetStorage();

  // Storage Keys - Centralized key management

  /// Secure Storage Keys (for sensitive data)
  static const String tokenKey = 'token';
  static const String refreshTokenKey = 'refreshToken';

  /// Local Storage Keys (for non-sensitive data)
  static const String userNameKey = 'userName';
  static const String emailKey = 'email';
  static const String userIdKey = 'userId';
  static const String rolesKey = 'roles';
  static const String languageKey = 'language';

  /// List of all secure storage keys
  static const List<String> secureStorageKeys = [tokenKey, refreshTokenKey];

  /// List of all local storage keys
  static const List<String> localStorageKeys = [
    userNameKey,
    emailKey,
    userIdKey,
    rolesKey,
    languageKey,
  ];

  // Secure Storage Methods (for sensitive data)

  /// Write to secure storage
  static Future<void> writeSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Read from secure storage
  static Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Delete from secure storage
  static Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Clear all secure storage
  static Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // Local Storage Methods (for non-sensitive data)

  /// Write to local storage
  static Future<void> writeLocal(String key, dynamic value) async {
    await _localStorage.write(key, value);
  }

  /// Read from local storage
  static T? readLocal<T>(String key) {
    return _localStorage.read<T>(key);
  }

  /// Delete from local storage
  static Future<void> deleteLocal(String key) async {
    _localStorage.remove(key);
  }

  /// Clear all local storage except specified keys
  static Future<void> clearLocalStorage({List<String>? keysToKeep}) async {
    if (keysToKeep != null && keysToKeep.isNotEmpty) {
      // Save values to restore later
      Map<String, dynamic> valuesToKeep = {};
      for (String key in keysToKeep) {
        final value = _localStorage.read(key);
        if (value != null) {
          valuesToKeep[key] = value;
        }
      }

      // Clear all storage
      await _localStorage.erase();

      // Restore saved values
      for (String key in valuesToKeep.keys) {
        await _localStorage.write(key, valuesToKeep[key]);
      }
    } else {
      await _localStorage.erase();
    }
  }

  // Convenience Methods

  /// Clear all storage (both secure and local) except specified local keys
  static Future<void> clearAllStorage({List<String>? localKeysToKeep}) async {
    await clearSecureStorage();
    await clearLocalStorage(keysToKeep: localKeysToKeep);
  }

  /// Check if secure storage has a key
  static Future<bool> hasSecureKey(String key) async {
    final value = await readSecure(key);
    return value != null;
  }

  /// Check if local storage has a key
  static bool hasLocalKey(String key) {
    return _localStorage.hasData(key);
  }

  // Token-specific convenience methods

  /// Save authentication tokens
  static Future<void> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    await writeSecure(tokenKey, token);
    await writeSecure(refreshTokenKey, refreshToken);
  }

  /// Get authentication token
  static Future<String?> getToken() async {
    return await readSecure(tokenKey);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await readSecure(refreshTokenKey);
  }

  /// Clear authentication tokens
  static Future<void> clearTokens() async {
    await deleteSecure(tokenKey);
    await deleteSecure(refreshTokenKey);
  }

  /// Save user data (non-sensitive)
  static Future<void> saveUserData({
    required String userName,
    required String email,
    required int userId,
    required List<String> roles,
  }) async {
    await writeLocal(userNameKey, userName);
    await writeLocal(emailKey, email);
    await writeLocal(userIdKey, userId);
    await writeLocal(rolesKey, roles);
  }

  /// Get user data
  static Map<String, dynamic> getUserData() {
    return {
      'userName': readLocal<String>(userNameKey),
      'email': readLocal<String>(emailKey),
      'userId': readLocal<int>(userIdKey),
      'roles': readLocal<List<dynamic>>(rolesKey),
    };
  }

  /// Clear user data
  static Future<void> clearUserData() async {
    await deleteLocal(userNameKey);
    await deleteLocal(emailKey);
    await deleteLocal(userIdKey);
    await deleteLocal(rolesKey);
  }
}
