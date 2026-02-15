import 'package:dartz/dartz.dart';

import '../../../../errors/failure.dart';
import '../models/firebase_auth_models.dart';

/// Abstract contract for Firebase authentication operations.

abstract class FirebaseAuthConsumer {
  // ============= AUTHENTICATION OPERATIONS =============

  /// Create a new user account with email and password
  Future<Either<Failure, AuthUser>> signUp({required SignUpRequest request});

  /// Sign in an existing user with email and password

  Future<Either<Failure, AuthUser>> signIn({required SignInRequest request});

  /// Sign out the current user
  Future<Either<Failure, Unit>> signOut();

  // ============= USER MANAGEMENT =============

  /// Get the current authenticated user
  Future<Either<Failure, AuthUser>> getCurrentUser();

  /// is signed in
  Future<Either<Failure, bool>> isSignedIn();

  /// Stream of authentication state changes
  Stream<AuthUser?> get authStateChanges;

  /// Stream of user changes (including profile updates)
  Stream<AuthUser?> get userChanges;
}
