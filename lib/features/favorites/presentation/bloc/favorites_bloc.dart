import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/services/firebase/crashlytics/crashlytics_logger.dart';
import '../../../branches/domain/entities/branch_entity.dart';
import '../../domain/repositories/favorites_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository repository;

  FavoritesBloc({required this.repository}) : super(const FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<RefreshFavoritesEvent>(_onRefreshFavorites);
    on<RemoveFavoriteFromListEvent>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(const FavoritesLoading());

      final result = await repository.getFavorites();

      result.fold(
        (failure) => emit(FavoritesError(message: failure.message)),
        (favorites) => emit(FavoritesLoaded(favorites: favorites)),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to load favorites',
        feature: 'Favorites',
      );
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> _onRefreshFavorites(
    RefreshFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final result = await repository.getFavorites();

      result.fold(
        (failure) => emit(FavoritesError(message: failure.message)),
        (favorites) => emit(FavoritesLoaded(favorites: favorites)),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to refresh favorites',
        feature: 'Favorites',
      );
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteFromListEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! FavoritesLoaded) return;

      final result = await repository.removeFavorite(event.branchId);

      result.fold(
        (failure) {
          CrashlyticsLogger.logError(
            Exception(failure.message),
            StackTrace.current,
            reason: 'Failed to remove favorite',
            feature: 'Favorites',
            context: ['branchId: ${event.branchId}'],
          );
        },
        (_) {
          final updatedFavorites = currentState.favorites
              .where((branch) => branch.id != event.branchId)
              .toList();
          emit(FavoritesLoaded(favorites: updatedFavorites));
        },
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to remove favorite',
        feature: 'Favorites',
      );
    }
  }
}
