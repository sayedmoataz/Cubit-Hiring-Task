import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';

class AccountTypeWidget extends StatelessWidget {
  final String accountType;
  final bool isBalanceHidden;
  final VoidCallback onToggleVisibility;
  const AccountTypeWidget({
    required this.accountType,
    required this.isBalanceHidden,
    required this.onToggleVisibility,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          accountType,
          style: TextStyle(
            fontSize: context.responsiveFontSize(14),
            color: AppColors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            isBalanceHidden
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
