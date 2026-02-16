import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../branches/domain/entities/branch_entity.dart';

class FavoriteBranchModel extends BranchEntity {
  final Timestamp addedAt;

  const FavoriteBranchModel({
    required super.id,
    required super.name,
    required super.type,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.isActive,
    required super.services,
    required super.workingHours,
    required this.addedAt,
    super.phone,
    super.isFavorite = true,
  });

  factory FavoriteBranchModel.fromFirestore(Map<String, dynamic> doc) {
    return FavoriteBranchModel(
      id: doc['branchId'] as String,
      name: doc['name'] as String,
      type: doc['type'] as String? ?? 'BRANCH',
      address: doc['address'] as String,
      latitude: (doc['lat'] as num).toDouble(),
      longitude: (doc['lng'] as num).toDouble(),
      isActive: doc['isActive'] as bool? ?? true,
      services: (doc['services'] as List<dynamic>?)?.cast<String>() ?? [],
      workingHours: doc['workingHours'] as String? ?? '',
      phone: doc['phone'] as String?,
      addedAt: doc['addedAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'branchId': id,
      'name': name,
      'type': type,
      'address': address,
      'lat': latitude,
      'lng': longitude,
      'isActive': isActive,
      'services': services,
      'workingHours': workingHours,
      if (phone != null) 'phone': phone,
      'addedAt': addedAt,
    };
  }

  factory FavoriteBranchModel.fromBranchEntity(BranchEntity branch) {
    return FavoriteBranchModel(
      id: branch.id,
      name: branch.name,
      type: branch.type,
      address: branch.address,
      latitude: branch.latitude,
      longitude: branch.longitude,
      isActive: branch.isActive,
      services: branch.services,
      workingHours: branch.workingHours,
      phone: branch.phone,
      addedAt: Timestamp.now(),
    );
  }

  BranchEntity toEntity() {
    return BranchEntity(
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
      isFavorite: true,
    );
  }
}
