import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../utils/validators.dart';

/// Domain model representing an authenticated user
class AuthUser extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;
  final bool emailVerified;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  const AuthUser({
    required this.uid,
    required this.emailVerified,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    this.creationTime,
    this.lastSignInTime,
  });

  /// Convert Firebase User to AuthUser domain model
  factory AuthUser.fromFirebaseUser(User user) {
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      creationTime: user.metadata.creationTime,
      lastSignInTime: user.metadata.lastSignInTime,
    );
  }

  /// Create a copy with updated fields
  AuthUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    bool? emailVerified,
    DateTime? creationTime,
    DateTime? lastSignInTime,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    phoneNumber,
    photoURL,
    emailVerified,
    creationTime,
    lastSignInTime,
  ];

  @override
  String toString() {
    return 'AuthUser(uid: $uid, email: $email, displayName: $displayName, '
        'emailVerified: $emailVerified)';
  }
}

/// Request model for user sign up
class SignUpRequest extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final bool acceptTerms;

  const SignUpRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.acceptTerms,
  });

  /// Validate the sign up request using centralized Validators
  ///
  /// Returns error message if validation fails, null otherwise
  String? validate() {
    // Validate name
    final nameError = Validators.name(name);
    if (nameError != null) return nameError;

    // Validate email
    final emailError = Validators.email(email);
    if (emailError != null) return emailError;

    // Validate phone
    final phoneError = Validators.phone(phone);
    if (phoneError != null) return phoneError;

    // Validate password
    final passwordError = Validators.password(password);
    if (passwordError != null) return passwordError;

    // Validate password confirmation
    final confirmError = Validators.confirmPassword(confirmPassword, password);
    if (confirmError != null) return confirmError;

    // Validate terms acceptance
    final termsError = Validators.acceptance(acceptTerms);
    if (termsError != null) return termsError;

    return null; // Validation passed
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    password,
    confirmPassword,
    acceptTerms,
  ];

  @override
  String toString() {
    return 'SignUpRequest(name: $name, email: $email, phone: $phone, '
        'acceptTerms: $acceptTerms)';
  }
}

/// Request model for user sign in
class SignInRequest extends Equatable {
  final String email;
  final String password;

  const SignInRequest({required this.email, required this.password});

  /// Validate the sign in request using centralized Validators
  ///
  /// Returns error message if validation fails, null otherwise
  String? validate() {
    // Validate email
    final emailError = Validators.email(email);
    if (emailError != null) return emailError;

    // Validate password (just check if it's not empty for sign-in)
    final passwordError = Validators.required(password, fieldName: 'Password');
    if (passwordError != null) return passwordError;

    return null; // Validation passed
  }

  @override
  List<Object?> get props => [email, password];

  @override
  String toString() {
    return 'SignInRequest(email: $email)';
  }
}
