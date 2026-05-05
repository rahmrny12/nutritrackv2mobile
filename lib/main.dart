import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'core/route_generator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.bmi,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
