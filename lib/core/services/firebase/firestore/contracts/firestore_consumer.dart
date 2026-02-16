import 'package:dartz/dartz.dart';

import '../../../../errors/failure.dart';

abstract class FirestoreConsumer {
  Future<Either<Failure, Unit>> setDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = false,
  });

  Future<Either<Failure, Map<String, dynamic>?>> getDocument({
    required String collection,
    required String documentId,
  });

  Future<Either<Failure, Unit>> deleteDocument({
    required String collection,
    required String documentId,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> getCollection({
    required String collection,
    int? limit,
    String? orderBy,
    bool descending = false,
  });

  Future<Either<Failure, bool>> documentExists({
    required String collection,
    required String documentId,
  });

  Future<Either<Failure, int>> getCollectionCount({required String collection});

  Stream<Either<Failure, Map<String, dynamic>?>> watchDocument({
    required String collection,
    required String documentId,
  });

  Stream<Either<Failure, List<Map<String, dynamic>>>> watchCollection({
    required String collection,
    int? limit,
    String? orderBy,
    bool descending = false,
  });

  Future<Either<Failure, Unit>> batchSet({
    required String collection,
    required Map<String, Map<String, dynamic>> documents,
  });

  Future<Either<Failure, Unit>> batchDelete({
    required String collection,
    required List<String> documentIds,
  });
}
