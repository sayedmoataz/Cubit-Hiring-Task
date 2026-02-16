import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing(ResponsiveSpacing.lg),
        vertical: context.spacing(ResponsiveSpacing.md),
      ),
      sliver: const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
