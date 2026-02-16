import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/transaction.dart';
import 'transaction_amount.dart';
import 'transaction_icon.dart';
import 'transaction_title.dart';

class TransactionItem extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionItem({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: info.spacing(ResponsiveSpacing.xs),
          ),
          child: Row(
            children: [
              TransactionIcon(transaction: transaction),
              SizedBox(width: info.spacing(ResponsiveSpacing.md)),
              TransactionTitle(transaction: transaction),
              TransactionAmount(transaction: transaction),
            ],
          ),
        );
      },
    );
  }
}
