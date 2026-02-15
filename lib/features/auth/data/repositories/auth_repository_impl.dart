import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, UserEntity>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final result = await remoteDatasource.signup(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );

    return result.fold(Left.new, (userModel) async {
      await localDatasource.cacheUser(userModel);
      return Right(userModel);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    final result = await remoteDatasource.login(
      email: email,
      password: password,
    );

    return result.fold(Left.new, (userModel) async {
      await localDatasource.cacheUser(userModel);
      return Right(userModel);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    final result = await remoteDatasource.getCurrentUser();

    return result.fold(Left.new, (userModel) async {
      await localDatasource.cacheUser(userModel);
      return Right(userModel);
    });
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    final result = await localDatasource.getCachedUser();

    return result.fold(Left.new, Right.new);
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    final result = await remoteDatasource.logout();

    return result.fold(Left.new, (_) async {
      await localDatasource.clearAuthData();
      return const Right(unit);
    });
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDatasource.authStateChanges;
  }
}
