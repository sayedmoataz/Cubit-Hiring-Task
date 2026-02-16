import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_technical_assessment/core/theme/colors.dart';

import '../../../../../core/utils/constants.dart';
import '../../../domain/entities/account_entity.dart';
import 'Account_type_widget.dart';
import 'account_details.dart';

class AccountBalanceCard extends StatelessWidget {
  final AccountEntity account;
  final bool isBalanceHidden;
  final VoidCallback onToggleVisibility;

  const AccountBalanceCard({
    required this.account,
    required this.isBalanceHidden,
    required this.onToggleVisibility,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Container(
          padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.lg)),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.blueDark, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountTypeWidget(
                accountType: account.accountType,
                isBalanceHidden: isBalanceHidden,
                onToggleVisibility: onToggleVisibility,
              ),
              SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
              Text(
                account.accountNumber,
                style: TextStyle(
                  fontSize: info.responsiveFontSize(12),
                  color: AppColors.white.withOpacity(0.7),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: info.spacing(ResponsiveSpacing.xs)),
              Text(
                isBalanceHidden
                    ? '••••••'
                    : '\$${account.balance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: info.responsiveFontSize(32),
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: info.spacing(ResponsiveSpacing.md)),
              AccountDetails(
                account: account,
                isBalanceHidden: isBalanceHidden,
              ),
            ],
          ),
        );
      },
    );
  }
}
