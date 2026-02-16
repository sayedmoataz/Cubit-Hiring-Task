import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';

class CardTypeWidget extends StatelessWidget {
  final String cardType;
  final bool isCardNumberHidden;
  final VoidCallback onToggleVisibility;
  const CardTypeWidget({
    required this.cardType,
    required this.isCardNumberHidden,
    required this.onToggleVisibility,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          cardType,
          style: TextStyle(
            fontSize: context.responsiveFontSize(16),
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            isCardNumberHidden
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.white,
            size: 20,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
