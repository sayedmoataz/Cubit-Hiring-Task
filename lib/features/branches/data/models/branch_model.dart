import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/branch_entity.dart';

part 'branch_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class BranchModel extends BranchEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String type;

  @HiveField(3)
  @override
  final String address;

  @HiveField(4)
  @JsonKey(name: 'lat')
  @override
  final double latitude;

  @HiveField(5)
  @JsonKey(name: 'lng')
  @override
  final double longitude;

  @HiveField(6)
  @JsonKey(name: 'is_active')
  @override
  final bool isActive;

  @HiveField(7)
  @override
  final List<String> services;

  @HiveField(8)
  @override
  final String? phone;

  @HiveField(9)
  @JsonKey(name: 'working_hours')
  @override
  final String workingHours;

  const BranchModel({
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
  }) : super(
         id: id,
         name: name,
         type: type,
         address: address,
         latitude: latitude,
         longitude: longitude,
         isActive: isActive,
         services: services,
         workingHours: workingHours,
         phone: phone,
       );

  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchModelToJson(this);

  factory BranchModel.fromEntity(BranchEntity entity) => BranchModel(
    id: entity.id,
    name: entity.name,
    type: entity.type,
    address: entity.address,
    latitude: entity.latitude,
    longitude: entity.longitude,
    isActive: entity.isActive,
    services: entity.services,
    workingHours: entity.workingHours,
    phone: entity.phone,
  );
}
