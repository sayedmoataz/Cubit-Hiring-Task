import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../domain/entities/transaction.dart';

class TransactionAmount extends StatelessWidget {
  const TransactionAmount({required this.transaction, super.key});
  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${transaction.isDebit ? '-' : '+'}\$${transaction.amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: context.responsiveFontSize(15),
            color: transaction.isDebit ? AppColors.error : AppColors.success,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.spacing(ResponsiveSpacing.xs) / 2),
        Text(
          _formatDate(transaction.date),
          style: TextStyle(
            fontSize: context.responsiveFontSize(12),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    if (date.isToday) {
      return DateFormat('h:mm a').format(date);
    } else if (date.isYesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
