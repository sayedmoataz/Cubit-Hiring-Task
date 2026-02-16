import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_assessment/core/utils/constants.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/context_extensions.dart';
import '../bloc/branches_bloc.dart';

class MapErrorWidget extends StatelessWidget {
  final String message;
  final bool canRetry;

  const MapErrorWidget({
    required this.message,
    super.key,
    this.canRetry = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Center(
          child: Container(
            margin: EdgeInsets.all(info.spacing(ResponsiveSpacing.lg)),
            padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.lg)),
            decoration: BoxDecoration(
              color: context.colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppConstants.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: info.responsiveValue(
                    mobile: 48.0,
                    tablet: 56.0,
                    desktop: 64.0,
                  ),
                ),
                SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: info.responsiveFontSize(16),
                    color: context.colorScheme.onSurface,
                  ),
                ),
                if (canRetry) ...[
                  SizedBox(height: info.spacing(ResponsiveSpacing.lg)),
                  ElevatedButton.icon(
                    onPressed: () => context.read<BranchesBloc>().add(
                      const LoadBranchesEvent(),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text(AppStrings.retry),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
