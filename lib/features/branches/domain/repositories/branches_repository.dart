import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/branch_entity.dart';

abstract class BranchesRepository {
  Future<Either<Failure, List<BranchEntity>>> getBranches({
    bool forceRefresh = false,
  });

  Future<Either<Failure, DateTime?>> getLastSyncTime();

  Future<Either<Failure, List<BranchEntity>>> getNearestBranches({
    required double latitude,
    required double longitude,
    int limit = 50,
  });
}
