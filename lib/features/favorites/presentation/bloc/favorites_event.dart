part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

final class LoadFavoritesEvent extends FavoritesEvent {
  const LoadFavoritesEvent();
}

final class RefreshFavoritesEvent extends FavoritesEvent {
  const RefreshFavoritesEvent();
}

final class RemoveFavoriteFromListEvent extends FavoritesEvent {
  final String branchId;

  const RemoveFavoriteFromListEvent({required this.branchId});

  @override
  List<Object> get props => [branchId];
}
