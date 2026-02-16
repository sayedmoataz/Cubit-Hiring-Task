import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/firebase/firestore/contracts/firestore_consumer.dart';
import '../models/favorite_branch_model.dart';

abstract class FavoritesRemoteDatasource {
  Future<Either<Failure, Unit>> addFavorite(FavoriteBranchModel favorite);

  Future<Either<Failure, Unit>> removeFavorite(String branchId);

  Future<Either<Failure, List<FavoriteBranchModel>>> getFavorites();

  Future<Either<Failure, bool>> isFavorite(String branchId);

  Stream<Either<Failure, List<FavoriteBranchModel>>> watchFavorites();
}

class FavoritesRemoteDatasourceImpl implements FavoritesRemoteDatasource {
  final FirestoreConsumer firestoreConsumer;
  final String userId;

  FavoritesRemoteDatasourceImpl({
    required this.firestoreConsumer,
    required this.userId,
  });

  String get _collection => 'users/$userId/favorite_branches';

  @override
  Future<Either<Failure, Unit>> addFavorite(
    FavoriteBranchModel favorite,
  ) async {
    return await firestoreConsumer.setDocument(
      collection: _collection,
      documentId: favorite.id,
      data: favorite.toFirestore(),
    );
  }

  @override
  Future<Either<Failure, Unit>> removeFavorite(String branchId) async {
    return await firestoreConsumer.deleteDocument(
      collection: _collection,
      documentId: branchId,
    );
  }

  @override
  Future<Either<Failure, List<FavoriteBranchModel>>> getFavorites() async {
    final result = await firestoreConsumer.getCollection(
      collection: _collection,
      orderBy: 'addedAt',
      descending: true,
    );

    return result.map((documents) {
      return documents.map((doc) {
        return FavoriteBranchModel.fromFirestore(doc);
      }).toList();
    });
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String branchId) async {
    return await firestoreConsumer.documentExists(
      collection: _collection,
      documentId: branchId,
    );
  }

  @override
  Stream<Either<Failure, List<FavoriteBranchModel>>> watchFavorites() {
    return firestoreConsumer
        .watchCollection(
          collection: _collection,
          orderBy: 'addedAt',
          descending: true,
        )
        .map((result) {
          return result.map((documents) {
            return documents.map((doc) {
              return FavoriteBranchModel.fromFirestore(doc);
            }).toList();
          });
        });
  }
}
