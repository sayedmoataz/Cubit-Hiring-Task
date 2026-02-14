import '../../features/home_page.dart';
import 'route_config.dart';

final routes = [
  RouteConfig(name: Routes.home, builder: (_, _) => const HomePage()),
];

/// Application Routes
class Routes {
  Routes._();

  static const String home = '/home';
}

class RouteArguments {
  // Verify Email Arguments
  static const String email = 'email';
}
