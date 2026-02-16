import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';

class MapShimmer extends StatefulWidget {
  const MapShimmer({super.key});

  @override
  State<MapShimmer> createState() => _MapShimmerState();
}

class _MapShimmerState extends State<MapShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              color: Colors.white.withValues(alpha: _animation.value * 0.5),
              child: Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.lg)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                        Text(
                          AppStrings.loadingBranches,
                          style: TextStyle(
                            fontSize: info.responsiveFontSize(14),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: info.spacing(ResponsiveSpacing.xs)),
                        Text(
                          AppStrings.findingNearbyLocations,
                          style: TextStyle(
                            fontSize: info.responsiveFontSize(12),
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
