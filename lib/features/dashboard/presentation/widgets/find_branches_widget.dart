import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';

class FindBranchesWidget extends StatelessWidget {
  const FindBranchesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () =>  sl<NavigationService>().navigateTo(Routes.map),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.map_outlined),
      label: Text(
        AppStrings.findBranch,
        style: TextStyle(
          fontSize: context.responsiveFontSize(14),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}