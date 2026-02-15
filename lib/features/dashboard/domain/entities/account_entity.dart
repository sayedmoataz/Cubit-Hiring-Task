import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String accountNumber;
  final String accountType;
  final double balance;
  final double availableBalance;
  final String accountHolderName;

  const AccountEntity({
    required this.accountNumber,
    required this.accountType,
    required this.balance,
    required this.availableBalance,
    required this.accountHolderName,
  });

  @override
  List<Object?> get props => [
    accountNumber,
    accountType,
    balance,
    availableBalance,
    accountHolderName,
  ];
}
