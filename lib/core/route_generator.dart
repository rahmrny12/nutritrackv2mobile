import 'package:flutter/material.dart';
import 'package:nutritrack/view/pages/auth/auth_page.dart';
import 'package:nutritrack/view/pages/auth/login_page.dart';
import 'package:nutritrack/view/pages/dashboard_page.dart';
import 'package:nutritrack/view/pages/log_food/confirm_log_food.dart';
import 'package:nutritrack/view/pages/log_food/initial_log_food.dart';
import 'package:nutritrack/view/pages/profile_page.dart';

class Routes {
  static const String auth = '/auth';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String confirmLogFood = '/confirm-log-food';
  static const String initialLogFood = '/initial-log-food';
  static const String profile = '/profile';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case Routes.confirmLogFood:
        return MaterialPageRoute(builder: (_) => const ConfirmLogFood());
      case Routes.initialLogFood:
        return MaterialPageRoute(builder: (_) => const InitialLogFood());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Route not found')),
        body: Center(
          child: Text('Halaman untuk route "$routeName" tidak ditemukan.'),
        ),
      ),
    );
  }
}
