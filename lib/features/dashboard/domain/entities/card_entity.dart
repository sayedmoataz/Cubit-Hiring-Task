import 'package:equatable/equatable.dart';

class CardEntity extends Equatable {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cardType;
  final String cardColor;

  const CardEntity({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardType,
    required this.cardColor,
  });

  @override
  List<Object?> get props => [
    cardNumber,
    cardHolderName,
    expiryDate,
    cardType,
    cardColor,
  ];
}
