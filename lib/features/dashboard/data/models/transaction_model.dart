import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.merchant,
    required super.amount,
    required super.category,
    required super.date,
    required super.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  factory TransactionModel.fromEntity(TransactionEntity entity) =>
      TransactionModel(
        id: entity.id,
        merchant: entity.merchant,
        amount: entity.amount,
        category: entity.category,
        date: entity.date,
        status: entity.status,
      );

  TransactionEntity toEntity() => this;
}
