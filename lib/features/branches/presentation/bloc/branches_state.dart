part of 'branches_bloc.dart';

sealed class BranchesState extends Equatable {
  const BranchesState();

  @override
  List<Object?> get props => [];
}

final class BranchesInitial extends BranchesState {
  const BranchesInitial();
}

final class BranchesLoading extends BranchesState {
  const BranchesLoading();
}

final class BranchesLoaded extends BranchesState {
  final List<BranchEntity> allBranches;
  final List<BranchEntity> nearestBranches;
  final LatLng? userLocation;
  final BranchEntity? selectedBranch;
  final bool isOffline;
  final DateTime? lastUpdated;

  const BranchesLoaded({
    required this.allBranches,
    required this.nearestBranches,
    this.userLocation,
    this.selectedBranch,
    this.isOffline = false,
    this.lastUpdated,
  });

  BranchesLoaded copyWith({
    List<BranchEntity>? allBranches,
    List<BranchEntity>? nearestBranches,
    LatLng? userLocation,
    BranchEntity? selectedBranch,
    bool? isOffline,
    DateTime? lastUpdated,
    bool clearSelectedBranch = false,
  }) {
    return BranchesLoaded(
      allBranches: allBranches ?? this.allBranches,
      nearestBranches: nearestBranches ?? this.nearestBranches,
      userLocation: userLocation ?? this.userLocation,
      selectedBranch: clearSelectedBranch
          ? null
          : (selectedBranch ?? this.selectedBranch),
      isOffline: isOffline ?? this.isOffline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
    allBranches,
    nearestBranches,
    userLocation,
    selectedBranch,
    isOffline,
    lastUpdated,
  ];
}

final class BranchesError extends BranchesState {
  final String message;
  final bool canRetry;

  const BranchesError({required this.message, this.canRetry = true});

  @override
  List<Object?> get props => [message, canRetry];
}
