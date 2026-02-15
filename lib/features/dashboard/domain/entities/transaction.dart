import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

enum TransactionCategory {
  shopping,
  food,
  transportation,
  bills,
  entertainment,
  transfer,
  atm,
  salary,
  other;

  IconData get icon {
    switch (this) {
      case TransactionCategory.shopping:
        return Icons.shopping_bag;
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.transportation:
        return Icons.directions_car;
      case TransactionCategory.bills:
        return Icons.receipt;
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.transfer:
        return Icons.swap_horiz;
      case TransactionCategory.atm:
        return Icons.atm;
      case TransactionCategory.salary:
        return Icons.account_balance_wallet;
      case TransactionCategory.other:
        return Icons.more_horiz;
    }
  }

  /// Get color for the category
  Color get color {
    switch (this) {
      case TransactionCategory.shopping:
        return AppColors.catShopping;
      case TransactionCategory.food:
        return AppColors.catFood;
      case TransactionCategory.transportation:
        return AppColors.catTransport;
      case TransactionCategory.bills:
        return AppColors.catBills;
      case TransactionCategory.entertainment:
        return AppColors.catEntertainment;
      case TransactionCategory.transfer:
        return AppColors.catTransfer;
      case TransactionCategory.atm:
        return AppColors.catAtm;
      case TransactionCategory.salary:
        return AppColors.catSalary;
      case TransactionCategory.other:
        return AppColors.catOther;
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
