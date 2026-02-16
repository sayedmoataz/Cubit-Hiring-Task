import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/context_extensions.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;
  final bool underline;

  const InfoRow({
    required this.icon,
    required this.text,
    super.key,
    this.textColor,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: context.colorScheme.onSurfaceVariant),
        SizedBox(width: context.spacing(ResponsiveSpacing.sm)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: context.responsiveFontSize(14),
              color: textColor ?? context.colorScheme.onSurface,
              decoration: underline ? TextDecoration.underline : null,
            ),
          ),
        ),
      ],
    );
  }
}
