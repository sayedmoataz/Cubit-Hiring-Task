import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/card_entity.dart';

part 'card_model.g.dart';

@JsonSerializable()
class CardModel extends CardEntity {
  const CardModel({
    required super.cardNumber,
    required super.cardHolderName,
    required super.expiryDate,
    required super.cardType,
    required super.cardColor,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardModelToJson(this);

  factory CardModel.fromEntity(CardEntity entity) => CardModel(
    cardNumber: entity.cardNumber,
    cardHolderName: entity.cardHolderName,
    expiryDate: entity.expiryDate,
    cardType: entity.cardType,
    cardColor: entity.cardColor,
  );

  CardEntity toEntity() => this;
}
