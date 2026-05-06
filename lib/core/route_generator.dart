import 'package:flutter/material.dart';
import 'package:nutritrack/view/pages/auth/auth_page.dart';
import 'package:nutritrack/view/pages/auth/bmi_page.dart';
import 'package:nutritrack/view/pages/auth/login_page.dart';
import 'package:nutritrack/view/pages/auth/register_page.dart';
import 'package:nutritrack/view/pages/dashboard_page.dart';
import 'package:nutritrack/view/pages/log_food/add_meal_page.dart';
import 'package:nutritrack/view/pages/log_food/confirm_log_food.dart';
import 'package:nutritrack/view/pages/log_food/initial_log_food.dart';
import 'package:nutritrack/view/pages/profile_page.dart';

class Routes {
  static const String dashboard = '/';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String confirmLogFood = '/confirm-log-food';
  static const String initialLogFood = '/initial-log-food';
  static const String addMeal = '/add-meal';
  static const String profile = '/profile';
  static const String bmi = '/bmi';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case Routes.bmi:
        return MaterialPageRoute(builder: (_) => const BMIPage());
      case Routes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case Routes.confirmLogFood:
        return MaterialPageRoute(builder: (_) => const ConfirmLogFood());
      case Routes.initialLogFood:
        return MaterialPageRoute(builder: (_) => const ConfirmLogFood());
      case Routes.addMeal:
        return MaterialPageRoute(builder: (_) => const AddMealPage());
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
