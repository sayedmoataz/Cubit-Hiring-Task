import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/branch_entity.dart';
import '../repositories/branches_repository.dart';

class GetBranchesUseCase {
  final BranchesRepository _repository;

  GetBranchesUseCase(this._repository);

  Future<Either<Failure, List<BranchEntity>>> call({
    bool forceRefresh = false,
  }) {
    return _repository.getBranches(forceRefresh: forceRefresh);
  }
}
