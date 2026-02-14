/// Application Configuration
class AppConfig {
  AppConfig._();

  // Environment
  static const bool enableLogging = true;

  // API Configuration
  static String get baseUrl {
    return 'https://raw.githubusercontent.com/ahmed-hosni-1/location-cubic/refs/heads/main/branches_atms_10000.json';
  }
}
