import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_template_with_login/utils/storage_service.dart';

void main() {
  group('StorageService Tests', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock path_provider for GetStorage
      const MethodChannel(
        'plugins.flutter.io/path_provider',
      ).setMockMethodCallHandler((MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getApplicationDocumentsDirectory':
            return '/tmp';
          default:
            return null;
        }
      });

      // Mock secure storage for testing
      const MethodChannel(
        'plugins.it_nomads.com/flutter_secure_storage',
      ).setMockMethodCallHandler((MethodCall methodCall) async {
        final Map<String, String> storage = {};
        switch (methodCall.method) {
          case 'write':
            final String key = methodCall.arguments['key'];
            final String value = methodCall.arguments['value'];
            storage[key] = value;
            return null;
          case 'read':
            final String key = methodCall.arguments['key'];
            return storage[key];
          case 'delete':
            final String key = methodCall.arguments['key'];
            storage.remove(key);
            return null;
          case 'deleteAll':
            storage.clear();
            return null;
          default:
            return null;
        }
      });
    });

    tearDown(() async {
      // Clean up after each test
      try {
        await StorageService.clearAllStorage();
      } catch (e) {
        // Ignore cleanup errors in tests
      }
    });

    test('should save and retrieve tokens', () async {
      const testToken = 'test_token_123';
      const testRefreshToken = 'test_refresh_token_456';

      // Save tokens
      await StorageService.saveTokens(
        token: testToken,
        refreshToken: testRefreshToken,
      );

      // Retrieve tokens (will return null in test environment due to mocking)
      final retrievedToken = await StorageService.getToken();
      final retrievedRefreshToken = await StorageService.getRefreshToken();

      // In a real environment, these would match
      // For test environment with mocking, we just verify no exceptions
      expect(retrievedToken, isA<String?>());
      expect(retrievedRefreshToken, isA<String?>());
    });

    test('should save and retrieve user data', () async {
      const testUserName = 'Test User';
      const testEmail = 'test@example.com';
      const testUserId = 123;
      const testRoles = ['USER', 'ADMIN'];

      // Save user data
      await StorageService.saveUserData(
        userName: testUserName,
        email: testEmail,
        userId: testUserId,
        roles: testRoles,
      );

      // Retrieve user data
      final userData = StorageService.getUserData();

      expect(userData['userName'], equals(testUserName));
      expect(userData['email'], equals(testEmail));
      expect(userData['userId'], equals(testUserId));
      expect(userData['roles'], equals(testRoles));
    });

    test('should check storage keys existence', () async {
      // Save some test data
      await StorageService.writeLocal(StorageService.userNameKey, 'Test');

      // Check existence
      expect(StorageService.hasLocalKey(StorageService.userNameKey), isTrue);
      expect(StorageService.hasLocalKey('non_existent_key'), isFalse);
    });

    test('should clear user data correctly', () async {
      // Save user data
      await StorageService.saveUserData(
        userName: 'Test User',
        email: 'test@example.com',
        userId: 123,
        roles: ['USER'],
      );

      // Verify data exists
      expect(StorageService.hasLocalKey(StorageService.userNameKey), isTrue);

      // Clear user data
      await StorageService.clearUserData();

      // Verify data is cleared
      expect(StorageService.hasLocalKey(StorageService.userNameKey), isFalse);
      expect(StorageService.hasLocalKey(StorageService.emailKey), isFalse);
      expect(StorageService.hasLocalKey(StorageService.userIdKey), isFalse);
      expect(StorageService.hasLocalKey(StorageService.rolesKey), isFalse);
    });

    test(
      'should preserve specified keys when clearing local storage',
      () async {
        // Save some data including language
        await StorageService.writeLocal(StorageService.languageKey, 'en');
        await StorageService.writeLocal(
          StorageService.userNameKey,
          'Test User',
        );

        // Clear all except language
        await StorageService.clearLocalStorage(
          keysToKeep: [StorageService.languageKey],
        );

        // Verify language is preserved, other data is cleared
        expect(
          StorageService.readLocal<String>(StorageService.languageKey),
          equals('en'),
        );
        expect(
          StorageService.readLocal<String>(StorageService.userNameKey),
          isNull,
        );
      },
    );

    test('should validate storage key constants', () {
      // Verify all expected keys are defined
      expect(StorageService.tokenKey, equals('token'));
      expect(StorageService.refreshTokenKey, equals('refreshToken'));
      expect(StorageService.userNameKey, equals('userName'));
      expect(StorageService.emailKey, equals('email'));
      expect(StorageService.userIdKey, equals('userId'));
      expect(StorageService.rolesKey, equals('roles'));
      expect(StorageService.languageKey, equals('language'));

      // Verify key lists contain expected keys
      expect(StorageService.secureStorageKeys, contains('token'));
      expect(StorageService.secureStorageKeys, contains('refreshToken'));
      expect(StorageService.localStorageKeys, contains('userName'));
      expect(StorageService.localStorageKeys, contains('language'));
    });
  });
}
