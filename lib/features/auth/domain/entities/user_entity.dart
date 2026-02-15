import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.emailVerified = false,
    this.createdAt,
    this.lastLoginAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phoneNumber,
    emailVerified,
    createdAt,
    lastLoginAt,
  ];

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, phoneNumber: $phoneNumber)';
  }
}
