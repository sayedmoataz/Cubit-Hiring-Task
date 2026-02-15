import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_technical_assessment/core/services/firebase/crashlytics/crashlytics_logger.dart';

import '../../../../errors/failure.dart';
import '../../../../errors/firebase_error_handler.dart';
import '../contracts/firebase_auth_consumer.dart';
import '../models/firebase_auth_models.dart';

/// Firebase Auth implementation of FirebaseAuthConsumer.
///
/// Features:
/// - Type-safe authentication operations
/// - Proper error handling and mapping
/// - Profile management (display name, phone number)
/// - Stream-based state management
/// - Comprehensive logging support
class FirebaseAuthConsumerImpl implements FirebaseAuthConsumer {
  final FirebaseAuth _firebaseAuth;
  final bool _enableLogging;

  FirebaseAuthConsumerImpl({
    FirebaseAuth? firebaseAuth,
    bool enableLogging = false,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _enableLogging = enableLogging;

  // ============= AUTHENTICATION OPERATIONS =============

  @override
  Future<Either<Failure, AuthUser>> signUp({
    required SignUpRequest request,
  }) async {
    try {
      // Validate the request
      final validationError = request.validate();
      if (validationError != null) {
        _log('Sign up validation failed: $validationError');
        return Left(ValidationFailure(message: validationError));
      }

      _log('Creating user account for: ${request.email}');

      // Create user with email and password
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: request.email.trim(),
            password: request.password,
          );

      final user = userCredential.user;
      if (user == null) {
        _log('User creation failed: user is null');
        return const Left(
          ServerFailure(message: 'Failed to create user account'),
        );
      }

      _log('User created successfully: ${user.uid}');

      // Update user profile with display name
      await user.updateDisplayName(request.name.trim());

      // Note: Firebase Auth doesn't natively support phone number storage
      // without phone authentication. You may want to store this in Firestore
      // or another database. For now, we'll log it.
      _log('User profile updated with name: ${request.name}');
      _log('Phone number (to be stored in DB): ${request.phone}');

      // Send email verification
      try {
        await user.sendEmailVerification();
        _log('Email verification sent to: ${user.email}');
      } catch (e) {
        _log('Failed to send email verification: $e');
        // Don't fail the signup if email verification fails
      }

      // Reload user to get updated profile
      await user.reload();
      final updatedUser = _firebaseAuth.currentUser;

      if (updatedUser == null) {
        return const Left(
          ServerFailure(message: 'Failed to retrieve updated user'),
        );
      }

      _log('Sign up completed successfully');
      return Right(AuthUser.fromFirebaseUser(updatedUser));
    } on FirebaseAuthException catch (e, stackTrace) {
      _log('Firebase auth error during sign up: ${e.code} - ${e.message}');
      CrashlyticsLogger.logError(e, stackTrace);
      return Left(FirebaseErrorHandler.handleAuthException(e));
    } catch (e, stackTrace) {
      _log('Unexpected error during sign up: $e');
      CrashlyticsLogger.logError(e, stackTrace);
      return Left(FirebaseErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signIn({
    required SignInRequest request,
  }) async {
    try {
      // Validate the request
      final validationError = request.validate();
      if (validationError != null) {
        _log('Sign in validation failed: $validationError');
        return Left(ValidationFailure(message: validationError));
      }

      _log('Signing in user: ${request.email}');

      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
            email: request.email.trim(),
            password: request.password,
          );

      final user = userCredential.user;
      if (user == null) {
        _log('Sign in failed: user is null');
        return const Left(UnauthorizedFailure(message: 'Failed to sign in'));
      }

      _log('Sign in successful: ${user.uid}');
      return Right(AuthUser.fromFirebaseUser(user));
    } on FirebaseAuthException catch (e, stackTrace) {
      _log('Firebase auth error during sign in: ${e.code} - ${e.message}');
      CrashlyticsLogger.logError(e, stackTrace);
      return Left(FirebaseErrorHandler.handleAuthException(e));
    } catch (e, stackTrace) {
      _log('Unexpected error during sign in: $e');
      CrashlyticsLogger.logError(e, stackTrace);
      return Left(FirebaseErrorHandler.handleException(e, stackTrace));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _log('User signed out successfully');
      return const Right(unit);
    } on FirebaseAuthException catch (e, stackTrace) {
      _log('Firebase auth error during sign out: ${e.code} - ${e.message}');
      CrashlyticsLogger.logError(e, stackTrace);
      return Left(FirebaseErrorHandler.handleAuthException(e));
    } catch (e, stackTrace) {
      _log('Unexpected error during sign out: $e');
      CrashlyticsLogger.logError(e, stackTrace);
      return Left(FirebaseErrorHandler.handleException(e, stackTrace));
    }
  }
  
  // ============= USER MANAGEMENT =============

  @override
  Future<Either<Failure, AuthUser>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        _log('Get current user failed: no user signed in');
        return const Left(
          UnauthorizedFailure(message: 'No user is currently signed in'),
        );
      }

      _log('Retrieved current user: ${user.uid}');
      return Right(AuthUser.fromFirebaseUser(user));
    } catch (e, stackTrace) {
      _log('Unexpected error getting current user: $e');
      CrashlyticsLogger.logError(e, stackTrace);
      return Left(FirebaseErrorHandler.handleException(e, stackTrace));
    }
  }

  // ============= STREAM LISTENERS =============

  @override
  Stream<AuthUser?> get authStateChanges {
    _log('Subscribing to auth state changes');
    return _firebaseAuth.authStateChanges().map((user) {
      if (user != null) {
        _log('Auth state changed: user signed in (${user.uid})');
        return AuthUser.fromFirebaseUser(user);
      } else {
        _log('Auth state changed: user signed out');
        return null;
      }
    });
  }

  @override
  Stream<AuthUser?> get userChanges {
    _log('Subscribing to user changes');
    return _firebaseAuth.userChanges().map((user) {
      if (user != null) {
        _log('User data changed: ${user.uid}');
        return AuthUser.fromFirebaseUser(user);
      } else {
        _log('User data changed: null');
        return null;
      }
    });
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      final user = _firebaseAuth.currentUser;
      _log('Checking if user is signed in: ${user != null}');
      return Right(user != null);
    } catch (e, stackTrace) {
      _log('Unexpected error checking if user is signed in: $e');
      CrashlyticsLogger.logError(e, stackTrace);
      return Left(FirebaseErrorHandler.handleException(e, stackTrace));
    }
  }

  // ============= HELPER METHODS =============

  /// Log message if logging is enabled
  void _log(String message) {
    if (_enableLogging) {
      debugPrint('[FirebaseAuthConsumer] $message');
    }
  }
}
