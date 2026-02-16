import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing(ResponsiveSpacing.xl)),
        child: Text(
          AppStrings.noTransactionsYet,
          style: TextStyle(
            fontSize: context.responsiveFontSize(14),
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
