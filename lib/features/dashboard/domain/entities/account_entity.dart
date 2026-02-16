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

  AccountEntity copyWith({
    String? accountNumber,
    String? accountType,
    double? balance,
    double? availableBalance,
    String? accountHolderName,
  }) {
    return AccountEntity(
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      balance: balance ?? this.balance,
      availableBalance: availableBalance ?? this.availableBalance,
      accountHolderName: accountHolderName ?? this.accountHolderName,
    );
  }
}
