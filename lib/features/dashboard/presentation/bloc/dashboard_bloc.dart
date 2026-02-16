import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/services/firebase/crashlytics/crashlytics_logger.dart';
import '../../../../core/utils/constants.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../data/mock/banking_mock_data.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/entities/card_entity.dart';
import '../../domain/entities/transaction.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AuthRepository authRepository;
  final NetworkInfo networkInfo;
  int _currentOffset = 0;
  static const int _pageSize = 5;

  DashboardBloc({required this.authRepository, required this.networkInfo})
    : super(const DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
    on<LoadMoreTransactionsEvent>(_onLoadMoreTransactions);
    on<ToggleBalanceVisibilityEvent>(_onToggleBalanceVisibility);
    on<ToggleCardVisibilityEvent>(_onToggleCardVisibility);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(const DashboardLoading());
      await Future.delayed(AppConstants.dashboardLoadingDuration);
      _currentOffset = 0;
      String accountHolderName = BankingMockData.account.accountHolderName;
      try {
        if (await networkInfo.isConnected) {
          final result = await authRepository.getCurrentUser();
          result.fold(
            (_) {},
            (user) => accountHolderName = user.name,
          );
        } else {
          final result = await authRepository.getCachedUser();
          result.fold(
            (_) {},
            (user) {
              if (user != null) {
                accountHolderName = user.name;
              }
            },
          );
        }
      } catch (e) {
        CrashlyticsLogger.logMessage(
          'Failed to load dashboard data',
          feature: 'Dashboard',
        );
      }

      final account = BankingMockData.account.copyWith(
        accountHolderName: accountHolderName,
      );
      const card = BankingMockData.card;
      final transactions = BankingMockData.getTransactions(
        _currentOffset,
        _pageSize,
      );
      _currentOffset += transactions.length;
      final hasMore = BankingMockData.hasMoreTransactions(_currentOffset);

      emit(
        DashboardLoaded(
          account: account,
          card: card,
          displayedTransactions: transactions,
          hasMoreTransactions: hasMore,
        ),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'Dashboard',
        reason: 'Failed to load dashboard data',
      );
      emit(const DashboardError('Failed to load dashboard. Please try again.'));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final currentState = state;
      bool preserveBalanceVisibility = false;
      bool preserveCardVisibility = true;
      if (currentState is DashboardLoaded) {
        preserveBalanceVisibility = currentState.isBalanceHidden;
        preserveCardVisibility = currentState.isCardNumberHidden;
      }
      emit(const DashboardLoading());
      await Future.delayed(const Duration(seconds: 1));
      _currentOffset = 0;
      String accountHolderName = BankingMockData.account.accountHolderName;
      try {
        if (await networkInfo.isConnected) {
          final result = await authRepository.getCurrentUser();
          result.fold(
            (_) {},
            (user) => accountHolderName = user.name,
          );
        } else {
          final result = await authRepository.getCachedUser();
          result.fold(
            (_) {},
            (user) {
              if (user != null) {
                accountHolderName = user.name;
              }
            },
          );
        }
      } catch (e) {
        CrashlyticsLogger.logMessage(
          'Failed to load dashboard data',
          feature: 'Dashboard',
        );
      }

      final account = BankingMockData.account.copyWith(
        accountHolderName: accountHolderName,
      );
      const card = BankingMockData.card;
      final transactions = BankingMockData.getTransactions(
        _currentOffset,
        _pageSize,
      );
      _currentOffset += transactions.length;
      final hasMore = BankingMockData.hasMoreTransactions(_currentOffset);

      emit(
        DashboardLoaded(
          account: account,
          card: card,
          displayedTransactions: transactions,
          hasMoreTransactions: hasMore,
          isBalanceHidden: preserveBalanceVisibility,
          isCardNumberHidden: preserveCardVisibility,
        ),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'Dashboard',
        reason: 'Failed to refresh dashboard',
      );
      emit(const DashboardError('Failed to refresh. Please try again.'));
    }
  }

  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactionsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! DashboardLoaded) return;
      if (currentState.isLoadingMore || !currentState.hasMoreTransactions) {
        return;
      }
      emit(currentState.copyWith(isLoadingMore: true));
      await Future.delayed(const Duration(milliseconds: 500));
      final newTransactions = BankingMockData.getTransactions(
        _currentOffset,
        _pageSize,
      );
      _currentOffset += newTransactions.length;
      final allTransactions = [
        ...currentState.displayedTransactions,
        ...newTransactions,
      ];
      final hasMore = BankingMockData.hasMoreTransactions(_currentOffset);
      emit(
        currentState.copyWith(
          displayedTransactions: allTransactions,
          hasMoreTransactions: hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'Dashboard',
        reason: 'Failed to load more transactions',
      );
      if (state is DashboardLoaded) {
        emit((state as DashboardLoaded).copyWith(isLoadingMore: false));
      }
    }
  }

  Future<void> _onToggleBalanceVisibility(
    ToggleBalanceVisibilityEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      emit(
        currentState.copyWith(isBalanceHidden: !currentState.isBalanceHidden),
      );
    }
  }

  Future<void> _onToggleCardVisibility(
    ToggleCardVisibilityEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      emit(
        currentState.copyWith(
          isCardNumberHidden: !currentState.isCardNumberHidden,
        ),
      );
    }
  }
}
