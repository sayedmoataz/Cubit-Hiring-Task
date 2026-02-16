part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

final class LoadDashboardEvent extends DashboardEvent {
  const LoadDashboardEvent();
}
final class RefreshDashboardEvent extends DashboardEvent {
  const RefreshDashboardEvent();
}

final class LoadMoreTransactionsEvent extends DashboardEvent {
  const LoadMoreTransactionsEvent();
}
final class ToggleBalanceVisibilityEvent extends DashboardEvent {
  const ToggleBalanceVisibilityEvent();
}

final class ToggleCardVisibilityEvent extends DashboardEvent {
  const ToggleCardVisibilityEvent();
}
