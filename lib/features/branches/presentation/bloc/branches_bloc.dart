import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/services/firebase/crashlytics/crashlytics_logger.dart';
import '../../domain/entities/branch_entity.dart';
import '../../domain/usecases/get_branches_usecase.dart';
import '../../domain/usecases/get_nearby_branches_usecase.dart';

part 'branches_event.dart';
part 'branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final GetBranchesUseCase _getBranchesUseCase;
  final GetNearbyBranchesUseCase _getNearbyBranchesUseCase;

  static const _defaultLocation = LatLng(30.0444, 31.2357);

  BranchesBloc({
    required GetBranchesUseCase getBranchesUseCase,
    required GetNearbyBranchesUseCase getNearbyBranchesUseCase,
  }) : _getBranchesUseCase = getBranchesUseCase,
       _getNearbyBranchesUseCase = getNearbyBranchesUseCase,
       super(const BranchesInitial()) {
    on<LoadBranchesEvent>(_onLoadBranches);
    on<RefreshBranchesEvent>(_onRefreshBranches);
    on<UpdateUserLocationEvent>(_onUpdateUserLocation);
    on<SelectBranchEvent>(_onSelectBranch);
    on<DeselectBranchEvent>(_onDeselectBranch);
    on<RecenterMapEvent>(_onRecenterMap);
    on<AddToFavoriteEvent>(_onAddToFavorite);
  }

  Future<void> _onLoadBranches(
    LoadBranchesEvent event,
    Emitter<BranchesState> emit,
  ) async {
    emit(const BranchesLoading());

    try {
      final userLocation = await _getUserLocation();
      final branchesResult = await _getBranchesUseCase();

      await branchesResult.fold(
        (failure) async {
          emit(BranchesError(message: failure.message));
        },
        (allBranches) async {
          final nearestResult = await _getNearbyBranchesUseCase(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude,
          );

          nearestResult.fold(
            (failure) {
              emit(BranchesError(message: failure.message));
            },
            (nearestBranches) {
              emit(
                BranchesLoaded(
                  allBranches: allBranches,
                  nearestBranches: nearestBranches,
                  userLocation: userLocation,
                  lastUpdated: DateTime.now(),
                ),
              );
            },
          );
        },
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, feature: 'branches');
      emit(BranchesError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onRefreshBranches(
    RefreshBranchesEvent event,
    Emitter<BranchesState> emit,
  ) async {
    final currentState = state;

    try {
      final branchesResult = await _getBranchesUseCase(forceRefresh: true);

      await branchesResult.fold(
        (failure) async {
          if (currentState is BranchesLoaded) {
            emit(currentState.copyWith(isOffline: true));
          } else {
            emit(BranchesError(message: failure.message));
          }
        },
        (allBranches) async {
          final userLocation = currentState is BranchesLoaded
              ? currentState.userLocation ?? _defaultLocation
              : await _getUserLocation();

          final nearestResult = await _getNearbyBranchesUseCase(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude,
          );

          nearestResult.fold(
            (failure) {
              emit(BranchesError(message: failure.message));
            },
            (nearestBranches) {
              emit(
                BranchesLoaded(
                  allBranches: allBranches,
                  nearestBranches: nearestBranches,
                  userLocation: userLocation,
                  lastUpdated: DateTime.now(),
                ),
              );
            },
          );
        },
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, feature: 'branches');
      if (currentState is BranchesLoaded) {
        emit(currentState.copyWith(isOffline: true));
      } else {
        emit(BranchesError(message: 'Refresh failed: $e'));
      }
    }
  }

  Future<void> _onUpdateUserLocation(
    UpdateUserLocationEvent event,
    Emitter<BranchesState> emit,
  ) async {
    if (state is! BranchesLoaded) return;
    final currentState = state as BranchesLoaded;

    try {
      final newLocation = LatLng(event.latitude, event.longitude);
      final nearestResult = await _getNearbyBranchesUseCase(
        latitude: event.latitude,
        longitude: event.longitude,
      );

      nearestResult.fold((_) {}, (nearestBranches) {
        emit(
          currentState.copyWith(
            userLocation: newLocation,
            nearestBranches: nearestBranches,
          ),
        );
      });
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, feature: 'branches');
    }
  }

  void _onSelectBranch(SelectBranchEvent event, Emitter<BranchesState> emit) {
    if (state is! BranchesLoaded) return;
    final currentState = state as BranchesLoaded;
    emit(currentState.copyWith(selectedBranch: event.branch));
  }

  void _onDeselectBranch(
    DeselectBranchEvent event,
    Emitter<BranchesState> emit,
  ) {
    if (state is! BranchesLoaded) return;
    final currentState = state as BranchesLoaded;
    emit(currentState.copyWith(clearSelectedBranch: true));
  }

  Future<void> _onRecenterMap(
    RecenterMapEvent event,
    Emitter<BranchesState> emit,
  ) async {
    if (state is! BranchesLoaded) return;
    final currentState = state as BranchesLoaded;

    try {
      final newLocation = await _getUserLocation();
      final nearestResult = await _getNearbyBranchesUseCase(
        latitude: newLocation.latitude,
        longitude: newLocation.longitude,
      );

      nearestResult.fold(
        (_) {
          emit(currentState.copyWith(userLocation: newLocation));
        },
        (nearestBranches) {
          emit(
            currentState.copyWith(
              userLocation: newLocation,
              nearestBranches: nearestBranches,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, feature: 'branches');
    }
  }

  Future<LatLng> _getUserLocation() async {
    try {
      var status = await Permission.location.status;
      if (status.isDenied) {
        status = await Permission.location.request();
      }

      if (status.isPermanentlyDenied) {
        debugPrint('[BranchesBloc] Location permanently denied');
        return _defaultLocation;
      }

      if (!status.isGranted) {
        debugPrint('[BranchesBloc] Location permission denied');
        return _defaultLocation;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('[BranchesBloc] Location services disabled');
        return _defaultLocation;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('[BranchesBloc] Failed to get location: $e');
      return _defaultLocation;
    }
  }

  void _onAddToFavorite(AddToFavoriteEvent event, Emitter<BranchesState> emit) {
    // TODO: Implement toggle favorite logic
    debugPrint('[BranchesBloc] Toggle favorite for branch: ${event.branchId}');
  }
}
