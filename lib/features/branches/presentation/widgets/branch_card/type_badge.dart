import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants.dart';

class TypeBadge extends StatelessWidget {
  final String label;
  final Color color;
  const TypeBadge({required this.label, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing(ResponsiveSpacing.sm),
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppConstants.radiusSM),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: context.responsiveFontSize(11),
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
