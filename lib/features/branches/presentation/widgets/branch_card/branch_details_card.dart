import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../domain/entities/branch_entity.dart';
import 'branch_data.dart';

class BranchDetailsCard extends StatelessWidget {
  final BranchEntity branch;
  final LatLng? userLocation;
  final VoidCallback onClose;

  const BranchDetailsCard({
    required this.branch,
    required this.onClose,
    super.key,
    this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return AnimatedContainer(
          duration: AppConstants.mediumAnimationDuration,
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusXL),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.md)),
          child: BranchData(
            branch: branch,
            userLocation: userLocation,
            onClose: onClose,
          ),
        );
      },
    );
  }
}
