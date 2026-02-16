part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  final AccountEntity account;
  final CardEntity card;
  final List<TransactionEntity> displayedTransactions;
  final bool hasMoreTransactions;
  final bool isBalanceHidden;
  final bool isCardNumberHidden;
  final bool isLoadingMore;

  const DashboardLoaded({
    required this.account,
    required this.card,
    required this.displayedTransactions,
    required this.hasMoreTransactions,
    this.isBalanceHidden = false,
    this.isCardNumberHidden = true,
    this.isLoadingMore = false,
  });

  DashboardLoaded copyWith({
    AccountEntity? account,
    CardEntity? card,
    List<TransactionEntity>? displayedTransactions,
    bool? hasMoreTransactions,
    bool? isBalanceHidden,
    bool? isCardNumberHidden,
    bool? isLoadingMore,
  }) {
    return DashboardLoaded(
      account: account ?? this.account,
      card: card ?? this.card,
      displayedTransactions:
          displayedTransactions ?? this.displayedTransactions,
      hasMoreTransactions: hasMoreTransactions ?? this.hasMoreTransactions,
      isBalanceHidden: isBalanceHidden ?? this.isBalanceHidden,
      isCardNumberHidden: isCardNumberHidden ?? this.isCardNumberHidden,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    account,
    card,
    displayedTransactions,
    hasMoreTransactions,
    isBalanceHidden,
    isCardNumberHidden,
    isLoadingMore,
  ];
}

final class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
