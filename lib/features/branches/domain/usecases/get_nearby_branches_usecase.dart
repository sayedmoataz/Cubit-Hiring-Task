import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/branch_entity.dart';
import '../repositories/branches_repository.dart';

class GetNearbyBranchesUseCase {
  final BranchesRepository _repository;

  GetNearbyBranchesUseCase(this._repository);

  Future<Either<Failure, List<BranchEntity>>> call({
    required double latitude,
    required double longitude,
    int limit = 50,
  }) {
    return _repository.getNearestBranches(
      latitude: latitude,
      longitude: longitude,
      limit: limit,
    );
  }
}
