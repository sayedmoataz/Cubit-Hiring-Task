import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_technical_assessment/features/branches/presentation/widgets/map_content.dart';

import '../../../../core/widgets/custom_toast/custom_toast.dart';
import '../../../../core/widgets/map/current_location_widget.dart';
import '../../../../core/widgets/map/map_utils.dart';
import '../bloc/branches_bloc.dart';
import 'branch_card/branch_details_card.dart';
import 'map_error_widget.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  late final MapController _mapController;
  bool _hasAnimatedToUserLocation = false;
  static const double defaultZoom = 12.0;
  static const double _recenterZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Scaffold(
          body: BlocConsumer<BranchesBloc, BranchesState>(
            listener: _handleStateChanges,
            builder: (context, state) {
              return Stack(
                children: [
                  // Map Layer
                  MapContent(
                    mapController: _mapController,
                    state: state,
                    info: info,
                    defaultZoom: defaultZoom,
                  ),

                  // Error Overlay
                  if (state is BranchesError)
                    MapErrorWidget(
                      message: state.message,
                      canRetry: state.canRetry,
                    ),

                  // My Location FAB
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: CurrentLocationWidget(
                      mapController: _mapController,
                      recenterZoom: _recenterZoom,
                    ),
                  ),
                  
                  // Branch Details Card
                  if (state is BranchesLoaded && state.selectedBranch != null)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: BranchDetailsCard(
                        branch: state.selectedBranch!,
                        userLocation: state.userLocation,
                        onClose: () => context.read<BranchesBloc>().add(
                          const DeselectBranchEvent(),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, BranchesState state) {
    if (state is BranchesLoaded) {
      if (state.userLocation != null && !_hasAnimatedToUserLocation) {
        MapUtils.animateMapTo(
          _mapController,
          state.userLocation!,
          defaultZoom,
          this,
        );
        _hasAnimatedToUserLocation = true;
      }
      if (state.isOffline) {
        CustomToast.info(context, 'Using cached data (offline mode)');
      }
    }
  }
}
