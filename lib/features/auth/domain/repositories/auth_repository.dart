import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Signup with email and password
  Future<Either<Failure, UserEntity>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  /// Login with email and password
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Get current user (online - from Firebase)
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Get cached user (offline - from Hive)
  Future<Either<Failure, UserEntity?>> getCachedUser();

  /// Logout
  Future<Either<Failure, Unit>> logout();

  /// Stream of auth state changes
  Stream<UserEntity?> get authStateChanges;
}
