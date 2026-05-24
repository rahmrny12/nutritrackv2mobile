import 'package:flutter/material.dart';
import 'package:nutritrack/core/local_storage.dart';
import 'package:nutritrack/view/pages/auth/auth_page.dart';
import 'package:nutritrack/view/pages/auth/bmi_page.dart';
import 'package:nutritrack/view/pages/auth/login_page.dart';
import 'package:nutritrack/view/pages/auth/register_page.dart';
import 'package:nutritrack/view/pages/auth/verify_otp_page.dart';
import 'package:nutritrack/view/pages/dashboard_page.dart';
import 'package:nutritrack/view/pages/edit_profile_page.dart';
import 'package:nutritrack/view/pages/log_food/add_meal_page.dart';
import 'package:nutritrack/view/pages/log_food/confirm_log_food.dart';
import 'package:nutritrack/view/pages/log_food/history_page.dart';
import 'package:nutritrack/view/pages/log_food/initial_log_food.dart';
import 'package:nutritrack/view/pages/main_page.dart';
import 'package:nutritrack/view/pages/mood_page.dart';
import 'package:nutritrack/view/pages/log_food/history_page.dart';
import 'package:nutritrack/view/pages/profile_page.dart';
import 'package:nutritrack/view/pages/recommendation_page.dart';
import 'package:nutritrack/view/pages/recommendation_page.dart';
import 'package:nutritrack/view/pages/screening/diabetes_screening_page.dart.dart';
import 'package:nutritrack/view/pages/screening/gout_screening_page.dart';
import 'package:nutritrack/view/pages/screening/heart_screening_page.dart.dart';
import 'package:nutritrack/view/viewmodel/log_food_viewmodel.dart';


class Routes {
  static const String main = '/';
  static const String dashboard = '/dashboard';
  static const String history = '/history';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyOtp = '/verify-otp';
  static const String confirmLogFood = '/confirm-log-food';
  static const String initialLogFood = '/initial-log-food';
  static const String addMeal = '/add-meal';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String bmi = '/bmi';
  static const String mood = '/mood';
  static const String gout_screening = '/gout';
  static const String diabetes_screening = '/diabetes';
  static const String heart_screening = '/heart';
  static const String recommendations = '/recommendations';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.main:
        return MaterialPageRoute(builder: (_) => const AuthCheckPage());
      case Routes.auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case Routes.verifyOtp:
        return MaterialPageRoute(builder: (_) => const VerifyOtpPage());
      case Routes.bmi:
        return MaterialPageRoute(builder: (_) => const BMIPage());
      case Routes.mood:
        return MaterialPageRoute(builder: (_) => const MoodPage());
      case Routes.gout_screening:
        return MaterialPageRoute(builder: (_) => const GoutScreeningPage());
      case Routes.diabetes_screening:
        return MaterialPageRoute(builder: (_) => const DiabetesScreeningPage());
      case Routes.heart_screening:
        return MaterialPageRoute(builder: (_) => const HeartScreeningPage());
      case Routes.recommendations:
        return MaterialPageRoute(builder: (_) => const RecommendationPage());
      case Routes.dashboard:
        return _protectedRoute(const DashboardPage());
      case Routes.confirmLogFood:
        final args = settings.arguments;

        if (args is! LogFoodViewModel) {
          return _errorRoute('Invalid or missing LogFoodViewModel');
        }

        return _protectedRoute(ConfirmLogFood(viewModel: args));
      case Routes.initialLogFood:
        return _protectedRoute(const InitialLogFood());
      case Routes.addMeal:
        return _protectedRoute(const AddMealPage());
      case Routes.profile:
        return _protectedRoute(const ProfilePage());
      case Routes.editProfile:
        return _protectedRoute(const EditProfilePage());
      case Routes.history:
        return MaterialPageRoute(builder: (_) => const HistoryPage());
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _protectedRoute(Widget page) {
    return MaterialPageRoute(
      builder: (_) => FutureBuilder<bool>(
        future: LocalStorage.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            return page;
          }

          return const AuthPage();
        },
      ),
    );
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

class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LocalStorage.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          return MainPage();
        }

        return const AuthPage();
      },
    );
  }
}
