import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/branches/presentation/pages/map_screen.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/home_page.dart';
import 'route_config.dart';

final routes = [
  RouteConfig(name: Routes.home, builder: (_, _) => const HomePage()),
  RouteConfig(name: Routes.login, builder: (_, _) => const LoginScreen()),
  RouteConfig(name: Routes.signup, builder: (_, _) => const SignUpScreen()),
  RouteConfig(
    name: Routes.dashboard,
    builder: (_, _) => const DashboardScreen(),
  ),
  RouteConfig(name: Routes.map, builder: (_, _) => const MapScreen()),
];

/// Application Routes
class Routes {
  Routes._();

  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String map = '/map';
}

class RouteArguments {
}
