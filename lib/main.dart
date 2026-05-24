import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'core/route_generator.dart';
import 'view/viewmodel/theme_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late ThemeViewModel _themeViewModel;

  @override
  void initState() {
    super.initState();
    _themeViewModel = ThemeViewModel();
  }

  @override
  void dispose() {
    _themeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<dynamic>(
      valueListenable: _themeViewModel,
      builder: (context, themeState, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _themeViewModel.currentTheme,
          initialRoute: Routes.auth,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
