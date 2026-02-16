import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import 'type_badge.dart';

class BranchBasicInfo extends StatelessWidget {
  final String branchName;
  final bool isBranch;
  final bool isActive;
  final bool isFavorite;
  final VoidCallback onClose;
  final VoidCallback? onFavorite;

  const BranchBasicInfo({
    required this.branchName,
    required this.isBranch,
    required this.isActive,
    required this.isFavorite,
    required this.onClose,
    this.onFavorite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                branchName,
                style: TextStyle(
                  fontSize: context.responsiveFontSize(18),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.spacing(ResponsiveSpacing.xs)),
              Row(
                children: [
                  TypeBadge(
                    label: isBranch ? 'Branch' : 'ATM',
                    color: isBranch ? AppColors.primary : Colors.teal,
                  ),
                  if (!isActive) ...[
                    SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
                    const TypeBadge(label: 'Inactive', color: AppColors.error),
                  ],
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: onFavorite,
        ),
        IconButton(icon: const Icon(Icons.close), onPressed: onClose),
      ],
    );
  }
}
