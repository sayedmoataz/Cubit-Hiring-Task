import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../branches/domain/entities/branch_entity.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, Unit>> addFavorite(BranchEntity branch);

  Future<Either<Failure, Unit>> removeFavorite(String branchId);

  Future<Either<Failure, List<BranchEntity>>> getFavorites();

  Future<Either<Failure, bool>> isFavorite(String branchId);

  Stream<Either<Failure, List<BranchEntity>>> watchFavorites();
}
