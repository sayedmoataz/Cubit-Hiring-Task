import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check if biometric is enabled on app start
final class CheckBiometricEvent extends AuthEvent {}

/// Signup with email/password
final class SignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;

  const SignupEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    password,
  ];
}

/// Login with email/password
final class LoginWithCredentialsEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginWithCredentialsEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Login with biometric
final class LoginWithBiometricEvent extends AuthEvent {}

/// Setup biometric after signup
final class SetupBiometricEvent extends AuthEvent {}

/// Skip biometric setup
final class SkipBiometricEvent extends AuthEvent {}

/// Logout (for testing or manual logout)
final class LogoutEvent extends AuthEvent {}
