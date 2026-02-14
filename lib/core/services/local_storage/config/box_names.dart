/// Box names constants for Hive storage.
///
/// Centralized constants to ensure consistency and avoid magic strings.
/// Similar to ResponseCode in the API layer.
class BoxNames {
  BoxNames._();

  // ============= USER DATA =============
  /// User profile and authentication data
  static const String user = 'user_box';

  /// User preferences and settings
  static const String settings = 'settings_box';

  /// User session data
  static const String session = 'session_box';

  /// Authentication tokens and biometric settings (ENCRYPTED!)
  static const String authData = 'auth_data_box';

  // ============= FEATURE DATA ============= 
  /// Branches and ATMs data (ENCRYPTED!)
  /// This contains location data for 10,000+ branches/ATMs
  static const String branches = 'branches_box';

  /// User's favorite branches (ENCRYPTED!)
  /// Syncs with Firestore
  static const String favorites = 'favorites_box';

  // ============= CACHE =============
  /// General purpose cache
  static const String cache = 'cache_box';

  /// API response cache
  static const String apiCache = 'api_cache_box';

  /// Image cache metadata
  static const String imageCache = 'image_cache_box';

  // ============= APP DATA =============
  /// App configuration and feature flags
  static const String appConfig = 'app_config_box';

  /// Onboarding and first-run data
  static const String onboarding = 'onboarding_box';

  /// Analytics and tracking data
  static const String analytics = 'analytics_box';

  // ============= OFFLINE DATA =============
  /// Offline queue for pending operations
  static const String offlineQueue = 'offline_queue_box';

  /// Draft content (posts, comments, etc.)
  static const String drafts = 'drafts_box';

  // ============= HELPER METHODS =============

  /// Get all box names
  static List<String> get allBoxNames => [
        user,
        settings,
        session,
        authData,
        branches,
        favorites,
        cache,
        apiCache,
        imageCache,
        appConfig,
        onboarding,
        analytics,
        offlineQueue,
        drafts,
      ];

  /// Boxes that MUST be encrypted (contains sensitive data)
  ///
  /// SECURITY CRITICAL:
  /// These boxes contain sensitive user data and MUST use encryption.
  /// - branches: Contains location data (privacy concern)
  /// - favorites: User's personal preferences
  /// - authData: Tokens, credentials, biometric settings
  /// - user: User profile data
  static List<String> get encryptedBoxes => [
        branches,
        favorites,
        authData,
        user,
      ];

  /// Boxes that can be safely preloaded on app start
  ///
  /// These are frequently accessed and small enough to keep in memory.
  /// Preloading improves app performance.
  static List<String> get preloadBoxes => [
        authData,
        settings,
        appConfig,
      ];

  /// Boxes that should be cleared on logout
  ///
  /// These contain user-specific data that should be removed
  /// when the user logs out.
  static List<String> get userSpecificBoxes => [
        user,
        authData,
        favorites,
        session,
        offlineQueue,
        drafts,
      ];

  /// Boxes that can be cleared for cache cleanup
  ///
  /// Safe to delete without losing critical data.
  /// Use for freeing up storage space.
  static List<String> get cacheBoxes => [
        cache,
        apiCache,
        imageCache,
      ];

  /// Check if a box name is valid
  static bool isValidBoxName(String boxName) {
    return allBoxNames.contains(boxName);
  }

  /// Check if a box requires encryption
  static bool requiresEncryption(String boxName) {
    return encryptedBoxes.contains(boxName);
  }

  /// Check if a box should be preloaded
  static bool shouldPreload(String boxName) {
    return preloadBoxes.contains(boxName);
  }

  /// Check if a box is user-specific (should clear on logout)
  static bool isUserSpecific(String boxName) {
    return userSpecificBoxes.contains(boxName);
  }

  /// Check if a box is cache (can be cleared)
  static bool isCache(String boxName) {
    return cacheBoxes.contains(boxName);
  }

  /// Get all box names that match a predicate
  static List<String> getBoxesWhere(bool Function(String) predicate) {
    return allBoxNames.where(predicate).toList();
  }
}