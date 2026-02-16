import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_strings.dart';
import '../bloc/favorites_bloc.dart';

class FavoriteErrorState extends StatelessWidget {
  final String message;
  const FavoriteErrorState({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
          SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
          Text(
            AppStrings.errorLoadingFavorites,
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: context.spacing(ResponsiveSpacing.xs)),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.spacing(ResponsiveSpacing.md)),
          FilledButton.icon(
            onPressed: () {
              context.read<FavoritesBloc>().add(const LoadFavoritesEvent());
            },
            icon: const Icon(Icons.refresh),
            label: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}
