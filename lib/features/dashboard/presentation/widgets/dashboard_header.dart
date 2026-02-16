// lib/features/dashboard/presentation/widgets/dashboard_header.dart
import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';

class DashboardHeader extends StatelessWidget {
  final String accountHolderName;
  const DashboardHeader({required this.accountHolderName, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        context.spacing(ResponsiveSpacing.lg),
        context.spacing(ResponsiveSpacing.md),
        context.spacing(ResponsiveSpacing.lg),
        0,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeBack,
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(14),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: context.spacing(ResponsiveSpacing.xs) / 2),
                Text(
                  accountHolderName,
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(20),
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
