import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
final class AuthInitial extends AuthState {}

/// Checking biometric availability
final class BiometricCheckLoading extends AuthState {}

/// Biometric is available and enabled
final class BiometricAvailable extends AuthState {}

/// Biometric is not available or not enabled
final class BiometricNotAvailable extends AuthState {}

/// Show login form (biometric not enabled or failed)
final class ShowLoginForm extends AuthState {}

/// Loading during auth operations
final class AuthLoading extends AuthState {}

/// Auth successful (online mode)
final class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// Auth successful (offline mode)
final class AuthSuccessOffline extends AuthState {
  final UserEntity user;

  const AuthSuccessOffline(this.user);

  @override
  List<Object?> get props => [user];
}

/// Prompting biometric setup (after signup)
final class BiometricSetupPrompt extends AuthState {}

/// Biometric setup successful
final class BiometricSetupSuccess extends AuthState {}

/// Biometric setup skipped
final class BiometricSetupSkipped extends AuthState {}

/// Biometric authentication failed
final class BiometricFailed extends AuthState {
  final String message;

  const BiometricFailed(this.message);

  @override
  List<Object?> get props => [message];
}

/// Auth error
final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Logged out
final class AuthLoggedOut extends AuthState {}
