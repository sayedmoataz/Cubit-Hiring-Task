// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      merchant: json['merchant'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: $enumDecode(_$TransactionCategoryEnumMap, json['category']),
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchant': instance.merchant,
      'amount': instance.amount,
      'category': _$TransactionCategoryEnumMap[instance.category]!,
      'date': instance.date.toIso8601String(),
      'status': instance.status,
    };

const _$TransactionCategoryEnumMap = {
  TransactionCategory.deposit: 'deposit',
  TransactionCategory.transfer: 'transfer',
  TransactionCategory.withdraw: 'withdraw',
  TransactionCategory.receive: 'receive',
};
