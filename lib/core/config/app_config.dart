/// Application Configuration
class AppConfig {
  AppConfig._();

  // Environment
  static const bool enableLogging = false;

  // API Configuration
  static String get baseUrl {
    return 'https://raw.githubusercontent.com/ahmed-hosni-1/location-cubic';
  }
}
