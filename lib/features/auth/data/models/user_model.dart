import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.phoneNumber,
    super.emailVerified,
    super.createdAt,
    super.lastLoginAt,
  });

  /// From JSON (for Hive storage)
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// To JSON (for Hive storage)
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// From Entity (domain → data)
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    id: entity.id,
    email: entity.email,
    name: entity.name,
    phoneNumber: entity.phoneNumber,
    emailVerified: entity.emailVerified,
    createdAt: entity.createdAt,
    lastLoginAt: entity.lastLoginAt,
  );

  /// From Firebase Auth User
  factory UserModel.fromFirebaseAuthUser({
    required String uid,
    required String email,
    required String name,
    required String phoneNumber,
    bool emailVerified = false,
    DateTime? createdAt,
  }) => UserModel(
    id: uid,
    email: email,
    name: name,
    phoneNumber: phoneNumber,
    emailVerified: emailVerified,
    createdAt: createdAt ?? DateTime.now(),
    lastLoginAt: DateTime.now(),
  );

  /// Copy with
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
