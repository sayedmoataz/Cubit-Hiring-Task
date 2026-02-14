/// Core Services Barrel Export
/// Export all services for easy imports
library;

// ========== Biometric ==========
export 'biometric/contracts/biometric_consumer.dart';
export 'biometric/factory/biometric_factory.dart';
export 'biometric/implementation/biometric_consumer_impl.dart';
export 'biometric/utils/biometric_preferences.dart';
// ========== Caching ==========
export 'caching/cache_keys.dart';
export 'caching/contract/cache_consumer.dart';
export 'caching/implementation/secure_storage_consumer.dart';
export 'caching/managers/app_prefs_manager.dart';
export 'caching/managers/cache_manager.dart';
// ========== Firebase ==========
export 'firebase/auth/contracts/firebase_auth_consumer.dart';
export 'firebase/auth/factory/firebase_auth_factory.dart';
export 'firebase/auth/implementation/firebase_auth_consumer_impl.dart';
export 'firebase/auth/models/firebase_auth_models.dart';
export 'firebase/auth/utils/auth_state_manager.dart';
export 'firebase/crashlytics/crashlytics_logger.dart';
// ========== Navigation ==========
export 'navigation/navigation_extensions.dart';
export 'navigation/navigation_service.dart';
export 'navigation/route_aware_mixin.dart';
export 'navigation/route_generator.dart';
// ========== General ==========
export 'performance/performance_service.dart';
