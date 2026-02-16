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
  final bool isFavorite;

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
    this.isFavorite = false,
  });

  bool get isOpen => isActive && !workingHours.contains('مغلق');

  bool get isBranch => type.toUpperCase() == 'BRANCH';

  bool get isATM => type.toUpperCase() == 'ATM';

  BranchEntity copyWith({
    String? id,
    String? name,
    String? type,
    String? address,
    double? latitude,
    double? longitude,
    bool? isActive,
    List<String>? services,
    String? phone,
    String? workingHours,
    bool? isFavorite,
  }) {
    return BranchEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      services: services ?? this.services,
      phone: phone ?? this.phone,
      workingHours: workingHours ?? this.workingHours,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

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
    isFavorite,
  ];
}
