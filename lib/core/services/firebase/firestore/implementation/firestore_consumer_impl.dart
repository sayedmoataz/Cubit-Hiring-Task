import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../errors/failure.dart';
import '../../../../errors/firebase_error_handler.dart';
import '../../crashlytics/crashlytics_logger.dart';
import '../contracts/firestore_consumer.dart';

class FirestoreConsumerImpl implements FirestoreConsumer {
  final FirebaseFirestore firestore;
  final bool enableLogging;
  FirestoreConsumerImpl({
    required this.firestore,
    this.enableLogging = false,
  }) ;


  @override
  Future<Either<Failure, Unit>> setDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    try {
      _log('Setting document: $collection/$documentId (merge: $merge)');

      await firestore
          .collection(collection)
          .doc(documentId)
          .set(data, SetOptions(merge: merge));

      _log('Document set successfully: $collection/$documentId');
      return const Right(unit);
    } on FirebaseException catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to set document',
        feature: 'Firestore',
        context: ['collection: $collection', 'documentId: $documentId'],
      );
      return Left(FirebaseErrorHandler.handle(e));
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Unexpected error setting document',
        feature: 'Firestore',
        context: ['collection: $collection', 'documentId: $documentId'],
      );
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      _log('Getting document: $collection/$documentId');

      final docSnapshot = await firestore
          .collection(collection)
          .doc(documentId)
          .get();

      if (!docSnapshot.exists) {
        _log('Document not found: $collection/$documentId');
        return const Right(null);
      }

      final data = docSnapshot.data();
      _log('Document retrieved: $collection/$documentId');
      return Right(data);
    } on FirebaseException catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to get document',
        feature: 'Firestore',
        context: ['collection: $collection', 'documentId: $documentId'],
      );
      return Left(FirebaseErrorHandler.handle(e));
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Unexpected error getting document',
        feature: 'Firestore',
        context: ['collection: $collection', 'documentId: $documentId'],
      );
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      _log('Deleting document: $collection/$documentId');

      await firestore.collection(collection).doc(documentId).delete();

      _log('Document deleted: $collection/$documentId');
      return const Right(unit);
    } on FirebaseException catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to delete document',
        feature: 'Firestore',
        context: ['collection: $collection', 'documentId: $documentId'],
      );
      return Left(FirebaseErrorHandler.handle(e));
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Unexpected error deleting document',
        feature: 'Firestore',
        context: ['collection: $collection', 'documentId: $documentId'],
      );
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCollection({
    required String collection,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      _log(
        'Getting collection: $collection (limit: $limit, orderBy: $orderBy, descending: $descending)',
      );

      Query query = firestore.collection(collection);

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();

      final documents = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      _log('Collection retrieved: $collection (${documents.length} documents)');
      return Right(documents);
    } on FirebaseException catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to get collection',
        feature: 'Firestore',
        context: [
          'collection: $collection',
          'limit: $limit',
          'orderBy: $orderBy',
        ],
      );
      return Left(FirebaseErrorHandler.handle(e));
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Unexpected error getting collection',
        feature: 'Firestore',
        context: ['collection: $collection'],
      );
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> documentExists({
    required String collection,
    required String documentId,
  }) async {
    try {
      _log('Checking if document exists: $collection/$documentId');

      final docSnapshot = await firestore
          .collection(collection)
          .doc(documentId)
          .get();

      final exists = docSnapshot.exists;
      _log('Document exists: $collection/$documentId = $exists');
      return Right(exists);
    } on FirebaseException catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to check document existence',
        feature: 'Firestore',
        context: ['collection: $collection', 'documentId: $documentId'],
      );
      return Left(FirebaseErrorHandler.handle(e));
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Unexpected error checking document existence',
        feature: 'Firestore',
        context: ['collection: $collection', 'documentId: $documentId'],
      );
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getCollectionCount({
    required String collection,
  }) async {
    try {
      _log('Getting collection count: $collection');

      final query = firestore.collection(collection);
      final aggregateQuery = await query.count().get();

      final count = aggregateQuery.count ?? 0;
      _log('Collection count: $collection = $count');
      return Right(count);
    } on FirebaseException catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to get collection count',
        feature: 'Firestore',
        context: ['collection: $collection'],
      );
      return Left(FirebaseErrorHandler.handle(e));
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Unexpected error getting collection count',
        feature: 'Firestore',
        context: ['collection: $collection'],
      );
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, Map<String, dynamic>?>> watchDocument({
    required String collection,
    required String documentId,
  }) {
    _log('Watching document: $collection/$documentId');

    return firestore
        .collection(collection)
        .doc(documentId)
        .snapshots()
        .map<Either<Failure, Map<String, dynamic>?>>((docSnapshot) {
          try {
            if (!docSnapshot.exists) {
              return const Right(null);
            }

            final data = docSnapshot.data();
            return Right(data);
          } on FirebaseException catch (e, stackTrace) {
            CrashlyticsLogger.logError(
              e,
              stackTrace,
              reason: 'Error in document stream',
              feature: 'Firestore',
              context: ['collection: $collection', 'documentId: $documentId'],
            );
            return Left(FirebaseErrorHandler.handle(e));
          } catch (e, stackTrace) {
            CrashlyticsLogger.logError(
              e,
              stackTrace,
              reason: 'Unexpected error in document stream',
              feature: 'Firestore',
              context: ['collection: $collection', 'documentId: $documentId'],
            );
            return Left(ServerFailure(message: e.toString()));
          }
        })
        .handleError((error, stackTrace) {
          CrashlyticsLogger.logError(
            error,
            stackTrace,
            reason: 'Stream error',
            feature: 'Firestore',
            context: ['collection: $collection', 'documentId: $documentId'],
          );
        });
  }

  @override
  Stream<Either<Failure, List<Map<String, dynamic>>>> watchCollection({
    required String collection,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) {
    _log(
      'Watching collection: $collection (limit: $limit, orderBy: $orderBy, descending: $descending)',
    );

    Query query = firestore.collection(collection);

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query
        .snapshots()
        .map<Either<Failure, List<Map<String, dynamic>>>>((querySnapshot) {
          try {
            final documents = querySnapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList();

            return Right(documents);
          } on FirebaseException catch (e, stackTrace) {
            CrashlyticsLogger.logError(
              e,
              stackTrace,
              reason: 'Error in collection stream',
              feature: 'Firestore',
              context: ['collection: $collection'],
            );
            return Left(FirebaseErrorHandler.handle(e));
          } catch (e, stackTrace) {
            CrashlyticsLogger.logError(
              e,
              stackTrace,
              reason: 'Unexpected error in collection stream',
              feature: 'Firestore',
              context: ['collection: $collection'],
            );
            return Left(ServerFailure(message: e.toString()));
          }
        })
        .handleError((error, stackTrace) {
          CrashlyticsLogger.logError(
            error,
            stackTrace,
            reason: 'Stream error',
            feature: 'Firestore',
            context: ['collection: $collection'],
          );
        });
  }

  @override
  Future<Either<Failure, Unit>> batchSet({
    required String collection,
    required Map<String, Map<String, dynamic>> documents,
  }) async {
    try {
      if (documents.isEmpty) {
        _log('Batch set skipped: no documents provided');
        return const Right(unit);
      }

      if (documents.length > 500) {
        return const Left(
          ValidationFailure(
            message: 'Batch operations are limited to 500 documents',
          ),
        );
      }

      _log('Batch setting ${documents.length} documents in: $collection');

      final batch = firestore.batch();

      for (final entry in documents.entries) {
        final docRef = firestore.collection(collection).doc(entry.key);
        batch.set(docRef, entry.value);
      }

      await batch.commit();

      _log('Batch set completed: ${documents.length} documents');
      return const Right(unit);
    } on FirebaseException catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to batch set documents',
        feature: 'Firestore',
        context: [
          'collection: $collection',
          'documentCount: ${documents.length}',
        ],
      );
      return Left(FirebaseErrorHandler.handle(e));
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Unexpected error in batch set',
        feature: 'Firestore',
        context: ['collection: $collection'],
      );
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> batchDelete({
    required String collection,
    required List<String> documentIds,
  }) async {
    try {
      if (documentIds.isEmpty) {
        _log('Batch delete skipped: no document IDs provided');
        return const Right(unit);
      }

      if (documentIds.length > 500) {
        return const Left(
          ValidationFailure(
            message: 'Batch operations are limited to 500 documents',
          ),
        );
      }

      _log('Batch deleting ${documentIds.length} documents from: $collection');

      final batch = firestore.batch();

      for (final docId in documentIds) {
        final docRef = firestore.collection(collection).doc(docId);
        batch.delete(docRef);
      }

      await batch.commit();

      _log('Batch delete completed: ${documentIds.length} documents');
      return const Right(unit);
    } on FirebaseException catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to batch delete documents',
        feature: 'Firestore',
        context: [
          'collection: $collection',
          'documentCount: ${documentIds.length}',
        ],
      );
      return Left(FirebaseErrorHandler.handle(e));
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Unexpected error in batch delete',
        feature: 'Firestore',
        context: ['collection: $collection'],
      );
      return Left(ServerFailure(message: e.toString()));
    }
  }

  void _log(String message) {
    if (enableLogging) {
      debugPrint('[FirestoreConsumer] $message');
    }
  }
}
