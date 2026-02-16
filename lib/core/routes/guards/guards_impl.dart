import 'package:flutter/material.dart';

import '../../di/injection_container.dart';
import '../../services/services.dart';
import '../routes.dart';
import 'i_guard.dart';

class AuthGuard implements Guard {
  final Future<bool> Function()? isAuthenticated;

  AuthGuard({this.isAuthenticated});

  @override
  Future<bool> canActivate(BuildContext context) async {
    if (isAuthenticated != null) {
      return await isAuthenticated!();
    }

    final prefs = sl<AppPrefsManager>();
    final token = await prefs.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  String? get redirectTo => Routes.login;
}
