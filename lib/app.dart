import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_technical_assessment/core/utils/app_strings.dart';

import 'core/config/app_config.dart';
import 'core/routes/routes.dart';
import 'core/services/navigation/navigation_service.dart';
import 'core/services/navigation/route_generator.dart';
import 'core/services/performance/performance_service.dart';
import 'core/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    // Initialize routes registry
    NavigationService.instance.initRoutes(routes);

    // Initialize remaining services after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await di.initRemainingServices();

      if (AppConfig.enableLogging) {
        PerformanceService.instance.printReport();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: Platform.isAndroid ? true : false,
      child: MaterialApp(
        navigatorKey: NavigationService.instance.navigationKey,
        navigatorObservers: [NavigationService.instance.routeObserver],
        onGenerateRoute: RouteGenerator(routes: routes).onGenerateRoute,
        onGenerateTitle: (context) => AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: Routes.login,
      ),
    );
  }
}
