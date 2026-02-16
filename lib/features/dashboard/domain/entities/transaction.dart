import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

enum TransactionCategory {
  deposit,
  transfer,
  withdraw,
  receive;

  IconData get icon {
    switch (this) {
      case TransactionCategory.deposit:
        return Icons.account_balance_wallet;
      case TransactionCategory.transfer:
        return Icons.swap_horiz;
      case TransactionCategory.withdraw:
        return Icons.money_off;
      case TransactionCategory.receive:
        return Icons.call_received;
    }
  }

  /// Get color for the category
  Color get color {
    switch (this) {
      case TransactionCategory.deposit:
        return AppColors.catSalary;
      case TransactionCategory.transfer:
        return AppColors.catTransfer;
      case TransactionCategory.withdraw:
        return AppColors.catShopping;
      case TransactionCategory.receive:
        return AppColors.catSalary;
    }
  }
}

class TransactionEntity extends Equatable {
  final String id;
  final String merchant;
  final double amount;
  final TransactionCategory category;
  final DateTime date;
  final String status;

  const TransactionEntity({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.category,
    required this.date,
    required this.status,
  });

  bool get isDebit => amount < 0;
  bool get isCredit => amount > 0;

  @override
  List<Object?> get props => [id, merchant, amount, category, date, status];
}
