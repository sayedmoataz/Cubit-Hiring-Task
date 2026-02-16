import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';

class TransactionListHeader extends StatelessWidget {
  const TransactionListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.transaction,
          style: TextStyle(
            fontSize: context.responsiveFontSize(18),
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: null,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            AppStrings.seeAll,

            style: TextStyle(
              fontSize: context.responsiveFontSize(14),
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
