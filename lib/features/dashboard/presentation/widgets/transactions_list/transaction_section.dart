import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/transaction.dart';
import 'transaction_item.dart';
import 'empty_list.dart';
import 'transaction_list_header.dart';

class TransactionSection extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const TransactionSection({required this.transactions, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TransactionListHeader(),
            SizedBox(height: info.spacing(ResponsiveSpacing.md)),
            if (transactions.isEmpty)
              const EmptyList()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
                itemBuilder: (context, index) {
                  return TransactionItem(transaction: transactions[index]);
                },
              ),
          ],
        );
      },
    );
  }
}
