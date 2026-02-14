import 'package:firebase_auth/firebase_auth.dart';

import '../contracts/firebase_auth_consumer.dart';
import '../implementation/firebase_auth_consumer_impl.dart';

/// Factory for creating configured FirebaseAuthConsumer instances.
///
/// Provides a fluent pattern for creating authentication service instances
/// with customizable configuration.
class FirebaseAuthFactory {
  FirebaseAuthFactory._();

  /// Create a fully configured FirebaseAuthConsumer instance
  ///
  /// [firebaseAuth] Optional custom FirebaseAuth instance for testing
  /// [enableLogging] Enable detailed logging for debugging (default: false)
  ///
  /// Returns a configured [FirebaseAuthConsumer] implementation
  static FirebaseAuthConsumer create({
    FirebaseAuth? firebaseAuth,
    bool enableLogging = false,
  }) {
    return FirebaseAuthConsumerImpl(
      firebaseAuth: firebaseAuth,
      enableLogging: enableLogging,
    );
  }
}
