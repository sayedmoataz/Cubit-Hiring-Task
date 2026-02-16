import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';

class FavoriteEmptyState extends StatelessWidget {
  const FavoriteEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: context.responsiveFontSize(80),
            color: theme.colorScheme.outline,
          ),
          SizedBox(height: context.spacing(ResponsiveSpacing.md)),
          Text(AppStrings.noFavoritesYet, style: theme.textTheme.titleLarge),
          SizedBox(height: context.spacing(ResponsiveSpacing.xs)),
          Text(
            AppStrings.addBranchesToYourFavoritesToSeeThemHere,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
