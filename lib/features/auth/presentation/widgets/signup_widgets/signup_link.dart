import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/services/services.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';

class SignUpLink extends StatelessWidget {
  const SignUpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            '${AppStrings.alreadyHaveAccount} ',
            style: TextStyle(
              fontSize: context.responsiveFontSize(14),
              color: AppColors.grey500,
            ),
          ),
          GestureDetector(
            onTap: () => sl<NavigationService>().navigateAndRemoveUntil(Routes.login),
            child: Text(
              AppStrings.signIn,
              style: TextStyle(
                fontSize: context.responsiveFontSize(14),
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
