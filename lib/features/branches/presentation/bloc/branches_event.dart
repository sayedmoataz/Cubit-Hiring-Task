part of 'branches_bloc.dart';

sealed class BranchesEvent extends Equatable {
  const BranchesEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBranchesEvent extends BranchesEvent {
  const LoadBranchesEvent();
}

final class RefreshBranchesEvent extends BranchesEvent {
  const RefreshBranchesEvent();
}

final class UpdateUserLocationEvent extends BranchesEvent {
  final double latitude;
  final double longitude;

  const UpdateUserLocationEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

final class SelectBranchEvent extends BranchesEvent {
  final BranchEntity branch;

  const SelectBranchEvent({required this.branch});

  @override
  List<Object?> get props => [branch];
}

final class DeselectBranchEvent extends BranchesEvent {
  const DeselectBranchEvent();
}

final class RecenterMapEvent extends BranchesEvent {
  const RecenterMapEvent();
}

final class AddToFavoriteEvent extends BranchesEvent {
  final String branchId;

  const AddToFavoriteEvent({required this.branchId});

  @override
  List<Object?> get props => [branchId];
}
