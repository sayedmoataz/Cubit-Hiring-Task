import 'app_strings.dart';

/// Form Validators
/// Provides validation functions for common form fields
/// Context-free validators that can be used in any layer of the application
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates if field is not empty
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired(fieldName ?? 'This field');
    }
    return null;
  }

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  /// Validates password strength
  /// By default requires minimum 6 characters (Firebase Auth requirement)
  /// Set [requireStrong] to true for additional strength requirements
  static String? password(
    String? value, {
    int minLength = 6,
    bool requireStrong = false,
  }) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < minLength) {
      return AppStrings.passwordMinLength(minLength);
    }

    if (requireStrong) {
      if (!value.contains(RegExp('[A-Z]'))) {
        return AppStrings.passwordUppercase;
      }

      if (!value.contains(RegExp('[a-z]'))) {
        return AppStrings.passwordLowercase;
      }

      if (!value.contains(RegExp('[0-9]'))) {
        return AppStrings.passwordNumber;
      }

      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        return AppStrings.passwordSpecial;
      }
    }

    return null;
  }

  /// Validates if passwords match
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordRequired;
    }

    if (value != password) {
      return AppStrings.passwordMismatch;
    }

    return null;
  }

  /// Validates phone number
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.phoneRequired;
    }

    // Remove spaces and dashes for validation
    final cleanedPhone = value.replaceAll(RegExp(r'[\s-]'), '');

    // Extract only digits
    final digitsOnly = cleanedPhone.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 10) {
      return AppStrings.phoneMinLength;
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(cleanedPhone)) {
      return AppStrings.phoneInvalid;
    }

    return null;
  }

  /// Validates name
  static String? name(String? value, {int minLength = 2}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }

    if (value.trim().length < minLength) {
      return AppStrings.nameMinLength(minLength);
    }

    return null;
  }

  /// Validates minimum length
  static String? minLength(String? value, int length, {String? fieldName}) {
    final field = fieldName ?? 'This field';
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired(field);
    }

    if (value.length < length) {
      return AppStrings.minLength(field, length);
    }

    return null;
  }

  /// Validates maximum length
  static String? maxLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > length) {
      return AppStrings.maxLength(fieldName ?? 'This field', length);
    }

    return null;
  }

  /// Validates numeric input
  static String? numeric(String? value, {String? fieldName}) {
    final field = fieldName ?? 'This field';
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired(field);
    }

    if (double.tryParse(value) == null) {
      return AppStrings.mustBeNumber(field);
    }

    return null;
  }

  /// Validates URL format
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.urlRequired;
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return AppStrings.urlInvalid;
    }

    return null;
  }

  /// Validates credit card number using Luhn algorithm
  static String? creditCard(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.creditCardRequired;
    }

    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return AppStrings.creditCardInvalid;
    }

    // Luhn algorithm
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return AppStrings.creditCardInvalid;
    }

    return null;
  }

  /// Validates date format (dd/MM/yyyy)
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.dateRequired;
    }

    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    if (!dateRegex.hasMatch(value)) {
      return AppStrings.dateFormat;
    }

    final parts = value.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return AppStrings.dateInvalid;
    }

    if (month < 1 || month > 12) {
      return AppStrings.dateMonthInvalid;
    }

    if (day < 1 || day > 31) {
      return AppStrings.dateDayInvalid;
    }

    return null;
  }

  /// Validates boolean checkbox acceptance (e.g., terms and conditions)
  static String? acceptance(bool? value, {String? fieldName}) {
    if (value == null || !value) {
      return AppStrings.acceptanceRequired(
        fieldName ?? AppStrings.defaultAcceptance,
      );
    }
    return null;
  }

  /// Combines multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
