import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/api/contracts/api_consumer.dart';
import '../../../../core/services/api/server_strings.dart';
import '../../../../core/services/firebase/crashlytics/crashlytics_logger.dart';
import '../models/branch_model.dart';

abstract class BranchesRemoteDatasource {
  Future<Either<Failure, List<BranchModel>>> fetchBranches();
}

class BranchesRemoteDatasourceImpl implements BranchesRemoteDatasource {
  final ApiConsumer apiConsumer;

  BranchesRemoteDatasourceImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, List<BranchModel>>> fetchBranches() async {
    try {
      final result = await apiConsumer.get<String>(
        endpoint: ServerStrings.branches,
        options: Options(responseType: ResponseType.plain),
        converter: (data) => data.toString(),
      );

      return result.fold(Left.new, (jsonString) async {
        try {
          final branches = await compute(_parseJsonIsolate, jsonString);
          return Right(branches);
        } catch (e) {
          return Left(ErrorHandler.handle(e));
        }
      });
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'branches',
        reason: 'Failed to fetch branches from API',
      );
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  static List<BranchModel> _parseJsonIsolate(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString) as List<dynamic>;
    return jsonData
        .map((json) => BranchModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
