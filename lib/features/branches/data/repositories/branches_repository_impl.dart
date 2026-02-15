import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/firebase/crashlytics/crashlytics_logger.dart';
import '../../domain/entities/branch_entity.dart';
import '../../domain/repositories/branches_repository.dart';
import '../constants/branches_cache_keys.dart';
import '../datasources/branches_local_datasource.dart';
import '../datasources/branches_remote_datasource.dart';

class BranchesRepositoryImpl implements BranchesRepository {
  final BranchesRemoteDatasource remoteDatasource;
  final BranchesLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  BranchesRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BranchEntity>>> getBranches({
    bool forceRefresh = false,
  }) async {
    try {
      // 1. Try cache first
      if (!forceRefresh) {
        final lastSync = (await localDatasource.getLastSyncTime()).getOrElse(
          () => null,
        );

        if (BranchesCacheKeys.isCacheValid(lastSync)) {
          final cached = (await localDatasource.getCachedBranches()).getOrElse(
            () => [],
          );

          if (cached.isNotEmpty) {
            debugPrint(
              '[BranchesRepo] Returning ${cached.length} cached branches',
            );

            final cacheAge = DateTime.now().difference(lastSync!);
            if (cacheAge.inHours >= 12) {
              debugPrint(
                '[BranchesRepo] Cache is ${cacheAge.inHours}h old, updating in background',
              );
              _updateCacheInBackground();
            }
            return Right(cached);
          }
        }
      }

      // 2. Offline fallback
      if (!await networkInfo.isConnected) {
        final cached = (await localDatasource.getCachedBranches()).getOrElse(
          () => [],
        );

        if (cached.isNotEmpty) {
          debugPrint(
            '[BranchesRepo] Offline — returning ${cached.length} expired cached branches',
          );
          return Right(cached);
        }
        return const Left(
          NetworkFailure(
            message: 'Internet connection required for first load',
          ),
        );
      }

      // 3. Fetch from network (parses in isolate)
      debugPrint('[BranchesRepo] Fetching fresh data from API...');
      final result = await remoteDatasource.fetchBranches();

      return result.fold(Left.new, (branches) async {
        // 4. Cache the results
        await localDatasource.cacheBranches(branches);
        debugPrint('[BranchesRepo] Cached ${branches.length} branches');
        return Right(branches);
      });
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'branches',
        reason: 'Failed to get branches',
      );
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  @override
  Future<Either<Failure, DateTime?>> getLastSyncTime() async {
    return localDatasource.getLastSyncTime();
  }

  @override
  Future<Either<Failure, List<BranchEntity>>> getNearestBranches({
    required double latitude,
    required double longitude,
    int limit = 50,
  }) async {
    try {
      final result = await getBranches();

      return result.fold(Left.new, (branches) {
        if (branches.isEmpty) return const Right([]);

        final withDistance = branches.map((branch) {
          final distance = Geolocator.distanceBetween(
            latitude,
            longitude,
            branch.latitude,
            branch.longitude,
          );
          return _BranchDistance(branch, distance);
        }).toList();

        // Sort by distance (O(n log n))
        withDistance.sort((a, b) => a.distance.compareTo(b.distance));

        // Take nearest N
        final nearest = withDistance.take(limit).map((e) => e.branch).toList();

        return Right(nearest);
      });
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'branches',
        reason: 'Failed to get nearest branches',
      );
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  Future<void> _updateCacheInBackground() async {
    try {
      if (!await networkInfo.isConnected) return;
      final result = await remoteDatasource.fetchBranches();
      await result.fold((_) async {}, (branches) async {
        await localDatasource.cacheBranches(branches);
        debugPrint('[BranchesRepo] Background cache update complete');
      });
    } catch (e) {
      debugPrint('[BranchesRepo] Background update failed: $e');
    }
  }
}

class _BranchDistance {
  final BranchEntity branch;
  final double distance;

  const _BranchDistance(this.branch, this.distance);
}
