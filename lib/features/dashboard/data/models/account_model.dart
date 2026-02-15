import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/account_entity.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel extends AccountEntity {
  const AccountModel({
    required super.accountNumber,
    required super.accountType,
    required super.balance,
    required super.availableBalance,
    required super.accountHolderName,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);

  factory AccountModel.fromEntity(AccountEntity entity) => AccountModel(
    accountNumber: entity.accountNumber,
    accountType: entity.accountType,
    balance: entity.balance,
    availableBalance: entity.availableBalance,
    accountHolderName: entity.accountHolderName,
  );

  AccountEntity toEntity() => this;
}
