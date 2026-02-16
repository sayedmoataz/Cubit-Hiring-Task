import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_toast/custom_toast.dart';
import '../bloc/favorites_bloc.dart';
import 'favorite_branch_card.dart';
import 'favorite_empty_state.dart';
import 'favorite_error_state.dart';
import 'favorites_shimmer.dart';

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.favorites)),
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesError) {
            CustomToast.error(context, state.message);
          }
        },
        builder: (context, state) {
          return switch (state) {
            FavoritesInitial() ||
            FavoritesLoading() => const FavoritesShimmer(),
            FavoritesLoaded(:final favorites) =>
              favorites.isEmpty
                  ? const FavoriteEmptyState()
                  : RefreshIndicator(
                      onRefresh: () async {
                        context.read<FavoritesBloc>().add(
                          const RefreshFavoritesEvent(),
                        );
                      },
                      child: ListView.builder(
                        padding: context.safePadding,
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final branch = favorites[index];
                          return FavoriteBranchCard(
                            branch: branch,
                            onRemove: () {
                              context.read<FavoritesBloc>().add(
                                RemoveFavoriteFromListEvent(
                                  branchId: branch.id,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            FavoritesError(:final message) => FavoriteErrorState(message: message),
          };
        },
      ),
    );
  }
}
