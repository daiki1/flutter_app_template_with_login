# Storage Management Documentation

This project uses a hybrid storage approach for better security and performance:

## Storage Types

### 1. **Secure Storage** (flutter_secure_storage)
Used for sensitive data that needs encryption at rest.

**Keys used:**
- `token` - JWT access token for API authentication
- `refreshToken` - JWT refresh token for token renewal

### 2. **Local Storage** (get_storage)
Used for non-sensitive user preferences and cached data.

**Keys used:**
- `userName` - User's display name
- `email` - User's email address
- `userId` - User's unique identifier
- `roles` - User's permission roles (List<String>)
- `language` - User's preferred language setting

## Usage Examples

### Storing Authentication Data
```dart
// Save tokens securely
await StorageService.saveTokens(
  token: 'jwt_access_token',
  refreshToken: 'jwt_refresh_token',
);

// Save user data locally
await StorageService.saveUserData(
  userName: 'John Doe',
  email: 'john@example.com',
  userId: 123,
  roles: ['USER', 'ADMIN'],
);
```

### Retrieving Data
```dart
// Get tokens
String? token = await StorageService.getToken();
String? refreshToken = await StorageService.getRefreshToken();

// Get user data
Map<String, dynamic> userData = StorageService.getUserData();
String? userName = userData['userName'];
String? email = userData['email'];
int? userId = userData['userId'];
List<String>? roles = userData['roles']?.cast<String>();
```

### Clearing Data
```dart
// Clear only tokens
await StorageService.clearTokens();

// Clear only user data
await StorageService.clearUserData();

// Clear everything except language preference
await StorageService.clearAllStorage(
  localKeysToKeep: [StorageService.languageKey]
);
```

## Benefits

1. **Security**: Sensitive tokens are encrypted using platform-specific secure storage
2. **Performance**: Non-sensitive data uses fast local storage
3. **Maintainability**: Centralized key management prevents typos and inconsistencies
4. **Flexibility**: Easy to migrate between storage types if needed

## Migration Notes

- **Before**: All data was stored in GetStorage (unencrypted)
- **After**: Tokens are now encrypted in secure storage, other data remains in local storage
- **Compatibility**: No data loss during migration - existing GetStorage data remains accessible
