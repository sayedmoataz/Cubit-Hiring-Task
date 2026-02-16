import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_assessment/features/dashboard/presentation/widgets/transactions_list/loading_indicator.dart';

import '../../../../core/theme/colors.dart';
import '../bloc/dashboard_bloc.dart';
import 'account_balance_widgets/account_balance_card.dart';
import 'credit_card_widgets/credit_card_widget.dart';
import 'dashboard_header.dart';
import 'find_branches_widget.dart';
import 'transactions_list/transaction_section.dart';

class DashboardDataWidget extends StatefulWidget {
  final DashboardLoaded state;
  const DashboardDataWidget({required this.state, super.key});

  @override
  State<DashboardDataWidget> createState() => _DashboardDataWidgetState();
}

class _DashboardDataWidgetState extends State<DashboardDataWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<DashboardBloc>().add(const LoadMoreTransactionsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(
                  const RefreshDashboardEvent(),
                );
                return;
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  DashboardHeader(
                    accountHolderName: widget.state.account.accountHolderName,
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: info.spacing(ResponsiveSpacing.lg),
                      vertical: info.spacing(ResponsiveSpacing.md),
                    ),
                    sliver: SliverToBoxAdapter(
                      child: AccountBalanceCard(
                        account: widget.state.account,
                        isBalanceHidden: widget.state.isBalanceHidden,
                        onToggleVisibility: () {
                          context.read<DashboardBloc>().add(
                            const ToggleBalanceVisibilityEvent(),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: info.spacing(ResponsiveSpacing.lg),
                    ),
                    sliver: SliverToBoxAdapter(
                      child: CreditCardWidget(
                        card: widget.state.card,
                        isCardNumberHidden: widget.state.isCardNumberHidden,
                        onToggleVisibility: () {
                          context.read<DashboardBloc>().add(
                            const ToggleCardVisibilityEvent(),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      info.spacing(ResponsiveSpacing.lg),
                      info.spacing(ResponsiveSpacing.xl),
                      info.spacing(ResponsiveSpacing.lg),
                      info.spacing(ResponsiveSpacing.md),
                    ),
                    sliver: SliverToBoxAdapter(
                      child: TransactionSection(
                        transactions: widget.state.displayedTransactions,
                      ),
                    ),
                  ),
                  if (widget.state.isLoadingMore) const LoadingIndicator(),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: info.spacing(ResponsiveSpacing.xl),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: const FindBranchesWidget(),
        );
      },
    );
  }
}
