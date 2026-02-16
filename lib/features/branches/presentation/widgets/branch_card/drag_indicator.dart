import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/context_extensions.dart';

class DragIndicator extends StatelessWidget {
  const DragIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: EdgeInsets.only(bottom: context.spacing(ResponsiveSpacing.sm)),
        decoration: BoxDecoration(
          color: context.colorScheme.outline.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppConstants.radiusSM),
        ),
      ),
    );
  }
}
