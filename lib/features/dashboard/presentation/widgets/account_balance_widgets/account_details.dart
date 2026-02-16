import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../domain/entities/account_entity.dart';
import 'details_item.dart';

class AccountDetails extends StatelessWidget {
  final AccountEntity account;
  final bool isBalanceHidden;
  const AccountDetails({
    required this.account,
    required this.isBalanceHidden,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DetailsItem(
            label: AppStrings.accountHolder,
            value: account.accountHolderName,
          ),
        ),
        Expanded(
          child: DetailsItem(
            label: AppStrings.available,
            value: isBalanceHidden
                ? '••••••'
                : '\$${account.availableBalance.toStringAsFixed(2)}',
          ),
        ),
      ],
    );
  }
}
