import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/url_luncher_utils.dart';
import '../../../domain/entities/branch_entity.dart';
import '../../bloc/branches_bloc.dart';
import 'branch_basic_info.dart';
import 'drag_indicator.dart';
import 'info_row_widget.dart';

class BranchData extends StatelessWidget {
  final BranchEntity branch;
  final LatLng? userLocation;
  final VoidCallback onClose;
  const BranchData({
    required this.branch,
    required this.onClose,
    super.key,
    this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    final distance = _calculateDistance();
    return ResponsiveBuilder(
      builder: (context, info) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragIndicator(),
            BranchBasicInfo(
              branchName: branch.name,
              isBranch: branch.isBranch,
              isActive: branch.isActive,
              onClose: onClose,
              onFavorite: () {
                context.read<BranchesBloc>().add(
                  AddToFavoriteEvent(branchId: branch.id),
                );
              },
            ),

            Divider(height: info.spacing(ResponsiveSpacing.lg)),

            // Address
            InfoRow(icon: Icons.location_on_outlined, text: branch.address),

            SizedBox(height: info.spacing(ResponsiveSpacing.sm)),

            // Working Hours
            InfoRow(icon: Icons.access_time, text: branch.workingHours),

            // Phone
            if (branch.phone != null && branch.phone!.isNotEmpty) ...[
              SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
              GestureDetector(
                onTap: () =>
                    UrlLuncherUtils.launchPhone(context, branch.phone!),
                child: InfoRow(
                  icon: Icons.phone_outlined,
                  text: branch.phone!,
                  textColor: AppColors.primary,
                  underline: true,
                ),
              ),
            ],

            // Distance
            if (distance != null) ...[
              SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
              InfoRow(
                icon: Icons.directions_walk,
                text: _formatDistance(distance),
              ),
            ],

            SizedBox(height: info.spacing(ResponsiveSpacing.lg)),

            // Get Directions Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    UrlLuncherUtils.launchDirections(context, branch),
                icon: const Icon(Icons.directions),
                label: Text(
                  AppStrings.getDirections,
                  style: TextStyle(fontSize: info.responsiveFontSize(14)),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: info.spacing(ResponsiveSpacing.sm),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double? _calculateDistance() {
    if (userLocation == null) return null;
    return Geolocator.distanceBetween(
      userLocation!.latitude,
      userLocation!.longitude,
      branch.latitude,
      branch.longitude,
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toInt()} m away';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km away';
  }
}
