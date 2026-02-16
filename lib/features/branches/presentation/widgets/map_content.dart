import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_technical_assessment/core/widgets/map/map_utils.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/widgets/map/custom_map_widget.dart';
import '../../domain/entities/branch_entity.dart';
import '../bloc/branches_bloc.dart';

class MapContent extends StatelessWidget {
  final BranchesState state;
  final MapController mapController;
  final ResponsiveInfo info;
  final double defaultZoom;
  const MapContent({
    required this.state,
    required this.mapController,
    required this.info,
    required this.defaultZoom,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    final LatLng center;
    final List<BranchEntity> branches;
    final LatLng? userLocation;

    if (state is BranchesLoaded) {
      center = state.userLocation ?? const LatLng(30.0444, 31.2357);
      branches = state.nearestBranches;
      userLocation = state.userLocation;
    } else {
      center = const LatLng(30.0444, 31.2357);
      branches = [];
      userLocation = null;
    }

    return CustomMapWidget(
      mapController: mapController,
      initialCenter: center,
      initialZoom: defaultZoom,
      onTap: (_, __) {
        if (state is BranchesLoaded && state.selectedBranch != null) {
          context.read<BranchesBloc>().add(const DeselectBranchEvent());
        }
      },
      children: [
        MarkerLayer(
          markers: [
            if (userLocation != null)
              MapUtils.buildUserLocationMarker(userLocation),
            ...branches.map(
              (branch) =>
                  MapUtils.buildBranchMarker(context, branch, state, info),
            ),
          ],
        ),
      ],
    );
  }
}
