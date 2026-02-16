import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';

class DetailsItem extends StatelessWidget {
  final String label;
  final String value;
  const DetailsItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.responsiveFontSize(10),
            color: AppColors.white.withOpacity(0.7),
          ),
        ),
        SizedBox(height: context.spacing(ResponsiveSpacing.xs) / 2),
        Text(
          value,
          style: TextStyle(
            fontSize: context.responsiveFontSize(14),
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
