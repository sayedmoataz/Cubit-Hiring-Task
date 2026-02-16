import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../branches/domain/entities/branch_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource_impl.dart';
import '../models/favorite_branch_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDatasourceImpl remoteDatasource;

  FavoritesRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, Unit>> addFavorite(BranchEntity branch) async {
    final favoriteModel = FavoriteBranchModel.fromBranchEntity(branch);
    return await remoteDatasource.addFavorite(favoriteModel);
  }

  @override
  Future<Either<Failure, Unit>> removeFavorite(String branchId) async {
    return await remoteDatasource.removeFavorite(branchId);
  }

  @override
  Future<Either<Failure, List<BranchEntity>>> getFavorites() async {
    final result = await remoteDatasource.getFavorites();
    return result.map((favorites) {
      return favorites.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String branchId) async {
    return await remoteDatasource.isFavorite(branchId);
  }

  @override
  Stream<Either<Failure, List<BranchEntity>>> watchFavorites() {
    return remoteDatasource.watchFavorites().map((result) {
      return result.map((favorites) {
        return favorites.map((model) => model.toEntity()).toList();
      });
    });
  }
}
