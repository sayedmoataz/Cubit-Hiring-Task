import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../features/branches/presentation/bloc/branches_bloc.dart';
import '../../utils/context_extensions.dart';
import 'map_utils.dart';

class CurrentLocationWidget extends StatefulWidget {
  final MapController mapController;
  final double recenterZoom;
  const CurrentLocationWidget({
    required this.mapController,
    required this.recenterZoom,
    super.key,
  });

  @override
  State<CurrentLocationWidget> createState() => _CurrentLocationWidgetState();
}

class _CurrentLocationWidgetState extends State<CurrentLocationWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        if (state is! BranchesLoaded) return const SizedBox.shrink();
        return FloatingActionButton(
          onPressed: () => _onMyLocationTapped(context, state),
          backgroundColor: context.colorScheme.primary,
          child: Icon(Icons.my_location, color: context.colorScheme.onPrimary),
        );
      },
    );
  }

  void _onMyLocationTapped(BuildContext context, BranchesLoaded state) {
    context.read<BranchesBloc>().add(const RecenterMapEvent());
    if (state.userLocation != null) {
      MapUtils.animateMapTo(
        widget.mapController,
        state.userLocation!,
        widget.recenterZoom,
        this,
      );
    }
  }
}
