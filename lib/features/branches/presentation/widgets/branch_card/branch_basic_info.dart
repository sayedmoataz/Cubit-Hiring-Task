import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import 'type_badge.dart';

class BranchBasicInfo extends StatefulWidget {
  final String branchName;
  final bool isBranch;
  final bool isActive;
  final VoidCallback onClose;
  final VoidCallback? onFavorite;

  const BranchBasicInfo({
    required this.branchName,
    required this.isBranch,
    required this.isActive,
    required this.onClose,
    this.onFavorite,
    super.key,
  });

  @override
  State<BranchBasicInfo> createState() => _BranchBasicInfoState();
}

class _BranchBasicInfoState extends State<BranchBasicInfo> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.branchName,
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
                    label: widget.isBranch ? 'Branch' : 'ATM',
                    color: widget.isBranch ? AppColors.primary : Colors.teal,
                  ),
                  if (!widget.isActive) ...[
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
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
            widget.onFavorite?.call();
          },
        ),
        IconButton(icon: const Icon(Icons.close), onPressed: widget.onClose),
      ],
    );
  }
}
