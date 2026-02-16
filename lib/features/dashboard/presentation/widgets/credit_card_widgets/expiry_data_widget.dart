import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';

class ExpiryDataWidget extends StatelessWidget {
  final String expiryDate;
  final bool isCardNumberHidden;
  const ExpiryDataWidget({required this.expiryDate, required this.isCardNumberHidden, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppStrings.expiry,
          style: TextStyle(
            fontSize: context.responsiveFontSize(10),
            color: AppColors.white.withOpacity(0.7),
          ),
        ),
        SizedBox(height: context.spacing(ResponsiveSpacing.xs) / 2),
        Text(
          isCardNumberHidden ? '****' : expiryDate,
          style: TextStyle(
            fontSize: context.responsiveFontSize(13),
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}