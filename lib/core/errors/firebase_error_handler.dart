import 'package:firebase_auth/firebase_auth.dart';

import 'failure.dart';


/// Utility class for mapping Firebase exceptions to domain Failure types
///
/// Centralizes error handling logic and provides consistent error messages
class FirebaseErrorHandler {
  /// Map FirebaseAuthException to appropriate Failure type
  ///
  /// Handles all common Firebase Auth error codes and maps them
  /// to the appropriate domain Failure type with user-friendly messages
  static Failure handleAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      // Authentication Failures
      case 'user-not-found':
        return const UnauthorizedFailure(
          message: 'No user found with this email address',
        );

      case 'wrong-password':
        return const UnauthorizedFailure(
          message: 'Incorrect password. Please try again',
        );

      case 'user-disabled':
        return const UnauthorizedFailure(
          message: 'This account has been disabled. Please contact support',
        );

      case 'invalid-credential':
        return const UnauthorizedFailure(
          message: 'The provided credentials are invalid',
        );

      case 'account-exists-with-different-credential':
        return const UnauthorizedFailure(
          message: 'An account already exists with a different sign-in method',
        );

      // Validation Failures
      case 'email-already-in-use':
        return const ValidationFailure(
          message: 'This email is already registered. Please sign in instead',
        );

      case 'invalid-email':
        return const ValidationFailure(
          message: 'The email address is not valid',
        );

      case 'weak-password':
        return const ValidationFailure(
          message: 'Password is too weak. Please use a stronger password',
        );

      case 'invalid-password':
        return const ValidationFailure(
          message: 'Password must be at least 6 characters',
        );

      // Network Failures
      case 'network-request-failed':
        return const NetworkFailure(
          message: 'Network error. Please check your internet connection',
        );

      // Server/Operation Failures
      case 'too-many-requests':
        return const ServerFailure(
          message: 'Too many requests. Please try again later',
        );

      case 'operation-not-allowed':
        return const ServerFailure(
          message: 'This operation is not allowed. Please contact support',
        );

      case 'internal-error':
        return const ServerFailure(
          message: 'An internal error occurred. Please try again',
        );

      // Session/Token Failures
      case 'requires-recent-login':
        return const UnauthorizedFailure(
          message:
              'This operation requires recent authentication. Please sign in again',
        );

      case 'user-token-expired':
        return const UnauthorizedFailure(
          message: 'Your session has expired. Please sign in again',
        );

      case 'invalid-user-token':
        return const UnauthorizedFailure(
          message: 'Invalid authentication token. Please sign in again',
        );

      // Provider Failures
      case 'provider-already-linked':
        return const ServerFailure(
          message: 'This provider is already linked to another account',
        );

      case 'credential-already-in-use':
        return const ServerFailure(
          message:
              'This credential is already associated with a different account',
        );

      // Generic fallback
      default:
        return ServerFailure(
          message: exception.message ?? 'An unexpected error occurred',
        );
    }
  }

  /// Map generic exceptions to Failure
  ///
  /// Handles non-Firebase exceptions and provides appropriate error messages
  static Failure handleException(dynamic exception, [StackTrace? stackTrace]) {
    if (exception is FirebaseAuthException) {
      return handleAuthException(exception);
    }

    // Handle other Firebase exceptions
    if (exception is FirebaseException) {
      return ServerFailure(
        message: exception.message ?? 'A Firebase error occurred',
      );
    }

    // Generic error handling
    return ServerFailure(message: exception.toString());
  }

  /// Check if error is a network error
  static bool isNetworkError(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return exception.code == 'network-request-failed';
    }
    return false;
  }

  /// Check if error requires re-authentication
  static bool requiresReauth(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return exception.code == 'requires-recent-login' ||
          exception.code == 'user-token-expired' ||
          exception.code == 'invalid-user-token';
    }
    return false;
  }

  /// Check if error is related to user credentials
  static bool isCredentialError(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return exception.code == 'user-not-found' ||
          exception.code == 'wrong-password' ||
          exception.code == 'invalid-credential';
    }
    return false;
  }
}
