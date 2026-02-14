import 'package:flutter/material.dart';

class AppStrings {
  final BuildContext _context;

  AppStrings._(this._context);

  static AppStrings of(BuildContext context) => AppStrings._(context);

  // ===========================================================================
  // VALIDATION STRINGS (Static for use in static Validators)
  // ===========================================================================

  // Generic
  static String fieldRequired(String fieldName) => '$fieldName is required';
  static String minLength(String fieldName, int length) =>
      '$fieldName must be at least $length characters';
  static String maxLength(String fieldName, int length) =>
      '$fieldName must not exceed $length characters';
  static String mustBeNumber(String fieldName) =>
      '$fieldName must be a valid number';
  static String get defaultRequired => 'This field is required';

  // Email
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Invalid email format';

  // Password
  static const String passwordRequired = 'Password is required';
  static String passwordMinLength(int length) =>
      'Password must be at least $length characters';
  static const String passwordUppercase =
      'Password must contain at least one uppercase letter';
  static const String passwordLowercase =
      'Password must contain at least one lowercase letter';
  static const String passwordNumber =
      'Password must contain at least one number';
  static const String passwordSpecial =
      'Password must contain at least one special character';
  static const String passwordMismatch = 'Passwords do not match';
  static const String confirmPasswordRequired = 'Please confirm your password';

  // Phone
  static const String phoneRequired = 'Phone number is required';
  static const String phoneMinLength =
      'Phone number must be at least 10 digits';
  static const String phoneInvalid = 'Invalid phone number format';

  // Name
  static const String nameRequired = 'Name is required';
  static String nameMinLength(int length) =>
      'Name must be at least $length characters';

  // URL
  static const String urlRequired = 'URL is required';
  static const String urlInvalid = 'Invalid URL format';

  // Credit Card
  static const String creditCardRequired = 'Credit card number is required';
  static const String creditCardInvalid = 'Invalid credit card number';

  // Date
  static const String dateRequired = 'Date is required';
  static const String dateFormat = 'Date must be in dd/MM/yyyy format';
  static const String dateInvalid = 'Invalid date';
  static const String dateMonthInvalid = 'Invalid month';
  static const String dateDayInvalid = 'Invalid day';

  // Acceptance
  static String acceptanceRequired(String fieldName) =>
      'You must accept $fieldName';
  static const String defaultAcceptance = 'the terms and conditions';

  static const String appName = 'Flutter Technical Assessment';

  // Time Ago
  static String timeAgoYears(int count) =>
      count == 1 ? '1 year ago' : '$count years ago';
  static String timeAgoMonths(int count) =>
      count == 1 ? '1 month ago' : '$count months ago';
  static String timeAgoDays(int count) =>
      count == 1 ? '1 day ago' : '$count days ago';
  static String timeAgoHours(int count) =>
      count == 1 ? '1 hour ago' : '$count hours ago';
  static String timeAgoMinutes(int count) =>
      count == 1 ? '1 minute ago' : '$count minutes ago';
  static const String timeAgoJustNow = 'Just now';

  // ===========================================================================
  // UI STRINGS (Instance getters for backward compatibility)
  // ===========================================================================

  // Offline
  String get youAreOffline => 'You are offline';
  String get youAreOfflineDescription =>
      'Please check your internet connection and try again';
  String get tryAgain => 'Try Again';

  // Permissions
  String get enableLocationAccess => 'Enable Location Access';
  String get enableCameraAccess => 'Enable Camera Access';
  String get enableGpsAccess => 'Enable GPS Access';

  String get locationAccessDescription =>
      'Please enable location access to use this feature';
  String get cameraAccessDescription =>
      'Please enable camera access to take photos';
  String get microphoneAccessDescription =>
      'Please enable microphone access to record audio';
  String get notificationAccessDescription =>
      'Please enable notifications to receive updates';
  String get gpsAccessDescription =>
      'Please enable GPS to use location services';

  String get openSettings => 'Open Settings';
}
