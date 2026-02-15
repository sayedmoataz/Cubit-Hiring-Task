import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/firebase/crashlytics/crashlytics_logger.dart';
import '../../../../core/services/local_storage/config/box_names.dart';
import '../../../../core/services/local_storage/contracts/hive_consumer.dart';
import '../constants/branches_cache_keys.dart';
import '../models/branch_model.dart';

abstract class BranchesLocalDatasource {
  Future<Either<Failure, List<BranchModel>>> getCachedBranches();
  Future<Either<Failure, Unit>> cacheBranches(List<BranchModel> branches);
  Future<Either<Failure, DateTime?>> getLastSyncTime();
  Future<Either<Failure, Unit>> clearCache();
}

class BranchesLocalDatasourceImpl implements BranchesLocalDatasource {
  final HiveConsumer hiveConsumer;
  const BranchesLocalDatasourceImpl({required this.hiveConsumer});

  @override
  Future<Either<Failure, List<BranchModel>>> getCachedBranches() async {
    try {
      final result = await hiveConsumer.getAll<BranchModel>(
        boxName: BoxNames.branches,
        converter: (data) => data as BranchModel,
      );

      return result.fold(Left.new, Right.new);
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'branches',
        reason: 'Failed to get cached branches',
      );
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  @override
  Future<Either<Failure, Unit>> cacheBranches(
    List<BranchModel> branches,
  ) async {
    try {
      await hiveConsumer.clearBox(boxName: BoxNames.branches);

      final entries = <String, BranchModel>{};
      for (final branch in branches) {
        entries[branch.id] = branch;
      }

      await hiveConsumer.saveAll<BranchModel>(
        boxName: BoxNames.branches,
        entries: entries,
      );

      await hiveConsumer.save<String>(
        boxName: BoxNames.cache,
        key: BranchesCacheKeys.lastSyncTime,
        value: DateTime.now().toIso8601String(),
      );

      return const Right(unit);
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'branches',
        reason: 'Failed to cache branches',
      );
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  @override
  Future<Either<Failure, DateTime?>> getLastSyncTime() async {
    try {
      final result = await hiveConsumer.get<String>(
        boxName: BoxNames.cache,
        key: BranchesCacheKeys.lastSyncTime,
        converter: (data) => data as String,
      );

      return result.fold(Left.new, (timestamp) {
        if (timestamp == null) return const Right(null);
        return Right(DateTime.tryParse(timestamp));
      });
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'branches',
        reason: 'Failed to get last sync time',
      );
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCache() async {
    try {
      await hiveConsumer.clearBox(boxName: BoxNames.branches);
      return const Right(unit);
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'branches',
        reason: 'Failed to clear cache',
      );
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }
}
