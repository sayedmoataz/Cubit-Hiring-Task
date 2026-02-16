import 'package:flutter/material.dart';

import '../../../domain/entities/transaction.dart';

class TransactionIcon extends StatelessWidget {
  const TransactionIcon({required this.transaction, super.key});
  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: transaction.category.color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        transaction.category.icon,
        size: 24,
        color: transaction.category.color,
      ),
    );
  }
}
