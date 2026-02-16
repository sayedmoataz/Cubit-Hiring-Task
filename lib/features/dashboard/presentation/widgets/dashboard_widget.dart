import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/dashboard_bloc.dart';
import 'dashboard_data_widget.dart';
import 'dashboard_error_widget.dart';
import 'dashboard_shimmer.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return switch (state) {
          DashboardInitial() => const DashboardShimmer(),
          DashboardLoading() => const DashboardShimmer(),
          DashboardError(:final message) => DashboardErrorWidget(message: message),
          DashboardLoaded() => DashboardDataWidget(state: state),
        };
      },
    );
  }
}
