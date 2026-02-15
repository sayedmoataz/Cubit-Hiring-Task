import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/firebase/auth/contracts/firebase_auth_consumer.dart';
import '../../../../core/services/firebase/auth/models/firebase_auth_models.dart';
import '../../../../core/services/firebase/crashlytics/crashlytics_logger.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<Either<Failure, UserModel>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> getCurrentUser();

  Future<Either<Failure, Unit>> logout();

  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuthConsumer firebaseAuthConsumer;

  AuthRemoteDatasourceImpl({required this.firebaseAuthConsumer});

  @override
  Future<Either<Failure, UserModel>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final result = await firebaseAuthConsumer.signUp(
        request: SignUpRequest(
          name: name,
          email: email,
          phone: phone,
          password: password,
          confirmPassword: password,
          acceptTerms: true,
        ),
      );

      return result.fold(
        Left.new,
        (authUser) => Right(
          UserModel.fromFirebaseAuthUser(
            uid: authUser.uid,
            email: authUser.email ?? email,
            name: authUser.displayName ?? name,
            phoneNumber: phone,
            emailVerified: authUser.emailVerified,
            createdAt: authUser.creationTime,
          ),
        ),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, reason: 'Failed to signup', feature: 'AuthRemoteDatasourceImpl');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await firebaseAuthConsumer.signIn(
        request: SignInRequest(email: email, password: password),
      );

      return result.fold(
        Left.new,
        (authUser) => Right(
          UserModel(
            id: authUser.uid,
            email: authUser.email ?? email,
            name: authUser.displayName ?? '',
            phoneNumber: authUser.phoneNumber ?? '',
            emailVerified: authUser.emailVerified,
            createdAt: authUser.creationTime,
            lastLoginAt: DateTime.now(),
          ),
        ),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, reason: 'Failed to login', feature: 'AuthRemoteDatasourceImpl');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final result = await firebaseAuthConsumer.getCurrentUser();

      return result.fold(
        Left.new,
        (authUser) => Right(
          UserModel(
            id: authUser.uid,
            email: authUser.email ?? '',
            name: authUser.displayName ?? '',
            phoneNumber: authUser.phoneNumber ?? '',
            emailVerified: authUser.emailVerified,
            createdAt: authUser.creationTime,
            lastLoginAt: authUser.lastSignInTime ?? DateTime.now(),
          ),
        ),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, reason: 'Failed to get current user', feature: 'AuthRemoteDatasourceImpl');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      return await firebaseAuthConsumer.signOut();
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, reason: 'Failed to logout', feature: 'AuthRemoteDatasourceImpl');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuthConsumer.authStateChanges.map((authUser) {
      if (authUser == null) return null;

      return UserModel(
        id: authUser.uid,
        email: authUser.email ?? '',
        name: authUser.displayName ?? '',
        phoneNumber: authUser.phoneNumber ?? '',
        emailVerified: authUser.emailVerified,
        createdAt: authUser.creationTime,
        lastLoginAt: authUser.lastSignInTime,
      );
    });
  }
}
