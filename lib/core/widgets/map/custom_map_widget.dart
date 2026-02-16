import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../utils/context_extensions.dart';

class CustomMapWidget extends StatelessWidget {
  final MapController mapController;
  final LatLng initialCenter;
  final double initialZoom;
  final List<Widget> children;
  final void Function(TapPosition, LatLng)? onTap;

  const CustomMapWidget({
    required this.mapController,
    required this.initialCenter,
    super.key,
    this.initialZoom = 13.0,
    this.children = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        onTap: onTap,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.cubic.banking',
          errorTileCallback: (tile, error, stackTrace) {
            tile.loadError = true;
          },
          tileBuilder: (context, tileWidget, tile) {
            if (tile.loadError) {
              return Container(
                color: context.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                child: Center(
                  child: Icon(
                    Icons.map_outlined,
                    size: 24,
                    color: context.colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                ),
              );
            }
            return tileWidget;
          },
        ),
        ...children,
      ],
    );
  }
}
