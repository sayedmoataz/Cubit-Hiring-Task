import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../domain/entities/transaction.dart';

class TransactionTitle extends StatelessWidget {
  const TransactionTitle({required this.transaction, super.key});
  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getTransactionType(transaction.category),
            style: TextStyle(
              fontSize: context.responsiveFontSize(15),
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.spacing(ResponsiveSpacing.xs) / 2),
          Text(
            transaction.merchant,
            style: TextStyle(
              fontSize: context.responsiveFontSize(12),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getTransactionType(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.deposit:
        return 'Deposit';
      case TransactionCategory.transfer:
        return 'Transfer';
      case TransactionCategory.withdraw:
        return 'Withdraw';
      case TransactionCategory.receive:
        return 'Receive';
    }
  }
}
