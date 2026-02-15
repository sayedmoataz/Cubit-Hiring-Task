import 'package:equatable/equatable.dart';

class BranchEntity extends Equatable {
  final String id;
  final String name;
  final String type;
  final String address;
  final double latitude;
  final double longitude;
  final bool isActive;
  final List<String> services;
  final String? phone;
  final String workingHours;

  const BranchEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.services,
    required this.workingHours,
    this.phone,
  });

  bool get isOpen => isActive && !workingHours.contains('مغلق');

  bool get isBranch => type.toUpperCase() == 'BRANCH';

  bool get isATM => type.toUpperCase() == 'ATM';

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    address,
    latitude,
    longitude,
    isActive,
    services,
    phone,
    workingHours,
  ];
}
