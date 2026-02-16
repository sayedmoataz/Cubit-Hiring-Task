import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../domain/entities/card_entity.dart';
import 'card_holder_widget.dart';
import 'card_type_widget.dart';
import 'expiry_data_widget.dart';

class CreditCardWidget extends StatelessWidget {
  final CardEntity card;
  final bool isCardNumberHidden;
  final VoidCallback onToggleVisibility;

  const CreditCardWidget({
    required this.card,
    required this.isCardNumberHidden,
    required this.onToggleVisibility,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final cardColor = card.cardColor.toColor();

        return Container(
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.lg)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cardColor, cardColor.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardTypeWidget(
                cardType: card.cardType,
                isCardNumberHidden: isCardNumberHidden,
                onToggleVisibility: onToggleVisibility,
              ),
              const Spacer(),

              // Card Number
              Text(
                isCardNumberHidden ? '•••• •••• •••• ••••' : card.cardNumber,
                style: TextStyle(
                  fontSize: info.responsiveFontSize(20),
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),

              const Spacer(),

              // Bottom row: Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Card holder and expiry
                  CardHolderWidget(cardHolderName: card.cardHolderName),
                  ExpiryDataWidget(
                    expiryDate: card.expiryDate,
                    isCardNumberHidden: isCardNumberHidden,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
