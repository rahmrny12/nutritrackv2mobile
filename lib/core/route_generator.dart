import 'package:flutter/material.dart';
import 'package:nutritrack/view/pages/auth/auth_page.dart';
import 'package:nutritrack/view/pages/auth/login_page.dart';
import 'package:nutritrack/view/pages/auth/register.dart';
import 'package:nutritrack/view/pages/dashboard_page.dart';
import 'package:nutritrack/view/pages/log_food/confirm_log_food.dart';
import 'package:nutritrack/view/pages/log_food/initial_log_food.dart';
import 'package:nutritrack/view/pages/profile_page.dart';
import 'package:nutritrack/view/pages/premium_page.dart';
import 'package:nutritrack/view/pages/edit_profile.dart';
import 'package:nutritrack/view/pages/langganan_page.dart';
import 'package:nutritrack/view/pages/skriningdiabetes_page.dart';
import 'package:nutritrack/view/pages/skriningasamurat.dart';


class Routes {
  static const String auth = '/auth';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String confirmLogFood = '/confirm-log-food';
  static const String initialLogFood = '/initial-log-food';
  static const String profile = '/profile_page';
  static const String register = '/register';
  static const String premium = '/premium_page';
  static const String edit = '/edit_profile';
  static const String langganan = '/langganan_page';
  static const String diabetes = '/diabetes_page';
  static const String asamurat = '/asamurat_page';
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
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.edit:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.premium:
        return MaterialPageRoute(builder: (_) => const PremiumScreen());
        case Routes.langganan:
      return MaterialPageRoute(builder: (_) => const LanggananPage());
        case Routes.diabetes:
      return MaterialPageRoute(builder: (_) => const SkriningDiabetesPage());
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