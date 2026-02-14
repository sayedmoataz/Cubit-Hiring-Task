import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../errors/failure.dart';
import '../../../biometric/contracts/biometric_consumer.dart';
import '../../../biometric/utils/biometric_preferences.dart';
import '../contracts/firebase_auth_consumer.dart';
import '../models/firebase_auth_models.dart';

/// Manages authentication state and biometric integration
class AuthStateManager {
  final FirebaseAuthConsumer _authConsumer;
  final BiometricConsumer _biometricConsumer;
  final BiometricPreferences _biometricPreferences;

  StreamSubscription<AuthUser?>? _authStateSubscription;

  AuthUser? _currentUser;
  AuthUser? get currentUser => _currentUser;

  AuthStateManager({
    required FirebaseAuthConsumer authConsumer,
    required BiometricConsumer biometricConsumer,
    required BiometricPreferences biometricPreferences,
  }) : _authConsumer = authConsumer,
       _biometricConsumer = biometricConsumer,
       _biometricPreferences = biometricPreferences;

  /// Initialize auth state listener
  void initialize() {
    _authStateSubscription = _authConsumer.authStateChanges.listen((user) {
      _currentUser = user;
    });
  }

  /// Dispose resources
  void dispose() {
    _authStateSubscription?.cancel();
  }

  /// Sign in with email and password
  Future<Either<Failure, AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    return await _authConsumer.signIn(
      request: SignInRequest(email: email, password: password),
    );
  }

  /// Sign in with biometric authentication
  ///
  /// Returns the cached user if biometric auth succeeds
  Future<Either<Failure, AuthUser>> signInWithBiometric() async {
    // Check if biometric is enabled
    final enabledResult = await _biometricPreferences.isBiometricEnabled();

    return await enabledResult.fold(Left.new, (enabled) async {
      if (!enabled) {
        return const Left(
          UnauthorizedFailure(message: 'Biometric login is not enabled'),
        );
      }

      // Authenticate with biometric
      final authResult = await _biometricConsumer.authenticateWithBiometric(
        reason: 'Authenticate to access your account',
      );

      return await authResult.fold(Left.new, (authenticated) async {
        if (!authenticated) {
          return const Left(
            UnauthorizedFailure(message: 'Biometric authentication failed'),
          );
        }

        // Get current user from Firebase
        return await _authConsumer.getCurrentUser();
      });
    });
  }

  /// Setup biometric authentication
  ///
  /// Checks if biometric is available and enables it
  Future<Either<Failure, bool>> setupBiometric() async {
    // Check if biometric is available
    final availableResult = await _biometricConsumer.isBiometricAvailable();

    return await availableResult.fold(Left.new, (available) async {
      if (!available) {
        return const Left(
          ServerFailure(
            message: 'Biometric authentication is not available on this device',
          ),
        );
      }

      // Check if biometric is enrolled
      final enrolledResult = await _biometricConsumer.hasBiometricEnrolled();

      return await enrolledResult.fold(Left.new, (enrolled) async {
        if (!enrolled) {
          return const Left(
            ServerFailure(
              message:
                  'No biometric credentials enrolled. Please enroll in device settings',
            ),
          );
        }

        // Test biometric authentication
        final authResult = await _biometricConsumer.authenticateWithBiometric(
          reason: 'Verify your identity to enable biometric login',
        );

        return await authResult.fold(Left.new, (authenticated) async {
          if (!authenticated) {
            return const Left(
              UnauthorizedFailure(message: 'Biometric verification failed'),
            );
          }

          // Enable biometric
          final enableResult = await _biometricPreferences.setBiometricEnabled(
            true,
          );

          return enableResult.fold(Left.new, (_) => const Right(true));
        });
      });
    });
  }

  /// Check if user is signed in
  Future<Either<Failure, bool>> isSignedIn() {
    return _authConsumer.isSignedIn();
  }

  /// Check if biometric is setup and available for this user
  Future<Either<Failure, bool>> canUseBiometric() async {
    final isSignedInResult = await isSignedIn();

    if (!isSignedInResult.fold((l) => false, (r) => r)) {
      return const Left(
        UnauthorizedFailure(message: 'No user is currently signed in'),
      );
    }

    final enabledResult = await _biometricPreferences.isBiometricEnabled();

    return enabledResult.fold(Left.new, (enabled) async {
      if (!enabled) {
        return const Left(
          UnauthorizedFailure(message: 'Biometric login is not enabled'),
        );
      }

      final availableResult = await _biometricConsumer.isBiometricAvailable();

      return availableResult.fold(Left.new, (available) async {
        if (!available) {
          return const Left(
            ServerFailure(
              message:
                  'Biometric authentication is not available on this device',
            ),
          );
        }

        return const Right(true);
      });
    });
  }
}
