import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../features/branches/domain/entities/branch_entity.dart';
import '../../../features/branches/presentation/bloc/branches_bloc.dart';
import '../../theme/colors.dart';
import '../../utils/constants.dart' show AppConstants;

class MapUtils {
  static Marker buildUserLocationMarker(LatLng position) {
    return Marker(
      point: position,
      width: 32,
      height: 32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.person_pin, color: AppColors.primary, size: 18),
        ),
      ),
    );
  }

  static Marker buildBranchMarker(
    BuildContext context,
    BranchEntity branch,
    BranchesState state,
    ResponsiveInfo info,
  ) {
    final isSelected =
        state is BranchesLoaded && state.selectedBranch?.id == branch.id;
    final markerSize = isSelected ? 48.0 : 36.0;

    final Color markerColor;
    if (!branch.isActive) {
      markerColor = AppColors.error;
    } else if (branch.isBranch) {
      markerColor = AppColors.primary;
    } else {
      markerColor = AppColors.primaryContainer;
    }

    return Marker(
      point: LatLng(branch.latitude, branch.longitude),
      width: markerSize,
      height: markerSize,
      child: GestureDetector(
        onTap: () =>
            context.read<BranchesBloc>().add(SelectBranchEvent(branch: branch)),
        child: AnimatedContainer(
          duration: AppConstants.shortAnimationDuration,
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.white : Colors.transparent,
              width: isSelected ? 3 : 0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: markerColor.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              branch.isBranch ? Icons.account_balance : Icons.atm,
              color: AppColors.white,
              size: isSelected ? 24 : 18,
            ),
          ),
        ),
      ),
    );
  }

  static void animateMapTo(
    MapController mapController,
    LatLng target,
    double zoom,
    TickerProvider vsync,
  ) {
    final latTween = Tween<double>(
      begin: mapController.camera.center.latitude,
      end: target.latitude,
    );
    final lngTween = Tween<double>(
      begin: mapController.camera.center.longitude,
      end: target.longitude,
    );
    final zoomTween = Tween<double>(
      begin: mapController.camera.zoom,
      end: zoom,
    );

    final controller = AnimationController(
      duration: AppConstants.mediumAnimationDuration,
      vsync: vsync,
    );
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
