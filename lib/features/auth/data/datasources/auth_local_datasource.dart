import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/firebase/crashlytics/crashlytics_logger.dart';
import '../../../../core/services/local_storage/config/box_names.dart';
import '../../../../core/services/local_storage/contracts/hive_consumer.dart';
import '../models/user_model.dart';

abstract class AuthLocalDatasource {
  Future<Either<Failure, Unit>> cacheUser(UserModel user);
  Future<Either<Failure, UserModel?>> getCachedUser();
  Future<Either<Failure, Unit>> saveAuthToken(String token);
  Future<Either<Failure, String?>> getAuthToken();
  Future<Either<Failure, Unit>> clearAuthData();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final HiveConsumer hiveConsumer;

  AuthLocalDatasourceImpl({required this.hiveConsumer});

  @override
  Future<Either<Failure, Unit>> cacheUser(UserModel user) async {
    try {
      final result = await hiveConsumer.save(
        boxName: BoxNames.authData,
        key: 'current_user',
        value: user.toJson(),
      );

      return result.fold(Left.new, (_) async {
        final saveTimeResult = await hiveConsumer.save(
          boxName: BoxNames.authData,
          key: 'last_login',
          value: DateTime.now().toIso8601String(),
        );

        return saveTimeResult.fold(Left.new, (_) => const Right(unit));
      });
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, reason: 'Failed to cache user', feature: 'AuthLocalDatasourceImpl');
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCachedUser() async {
    try {
      final result = await hiveConsumer.get(
        boxName: BoxNames.authData,
        key: 'current_user',
        converter: (data) {
          final json = Map<String, dynamic>.from(data as Map);
          return UserModel.fromJson(json);
        },
      );
      return result;
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, reason: 'Failed to get cached user', feature: 'AuthLocalDatasourceImpl');
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveAuthToken(String token) async {
    try {
      final result = await hiveConsumer.save(
        boxName: BoxNames.authData,
        key: 'auth_token',
        value: token,
      );

      return result.fold(Left.new, (_) => const Right(unit));
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, reason: 'Failed to save auth token', feature: 'AuthLocalDatasourceImpl');
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getAuthToken() async {
    try {
      final result = await hiveConsumer.get(
        boxName: BoxNames.authData,
        key: 'auth_token',
        converter: (data) => data as String,
      );
      return result;
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, reason: 'Failed to get auth token', feature: 'AuthLocalDatasourceImpl');
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAuthData() async {
    try {
      final result = await hiveConsumer.clearBox(boxName: BoxNames.authData);

      return result.fold(Left.new, (_) => const Right(unit));
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, reason: 'Failed to clear auth data', feature: 'AuthLocalDatasourceImpl');
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
