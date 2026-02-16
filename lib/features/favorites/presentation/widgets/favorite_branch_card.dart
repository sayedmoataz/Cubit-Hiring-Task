import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../branches/domain/entities/branch_entity.dart';

class FavoriteBranchCard extends StatelessWidget {
  final BranchEntity branch;
  final VoidCallback onRemove;

  const FavoriteBranchCard({
    required this.branch,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ResponsiveBuilder(
      builder: (context, info) {
        return Card(
          margin: EdgeInsets.only(bottom: info.spacing(ResponsiveSpacing.md)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: info.spacing(ResponsiveSpacing.md),
              vertical: info.spacing(ResponsiveSpacing.sm),
            ),
            leading: CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.location_on,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(
              branch.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                Text(
                  branch.address,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: info.spacing(ResponsiveSpacing.xs)),
                Text(
                  branch.workingHours,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite),
              color: colorScheme.error,
              onPressed: onRemove,
              tooltip: 'Remove from favorites',
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
