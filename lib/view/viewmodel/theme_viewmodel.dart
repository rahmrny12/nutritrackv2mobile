import 'package:flutter/material.dart';
import 'package:nutritrack/core/app_theme.dart';
import 'theme_state.dart';

class ThemeViewModel extends ValueNotifier<ThemeState> {
  static final ThemeViewModel _instance = ThemeViewModel._internal();

  factory ThemeViewModel() => _instance;

  ThemeViewModel._internal()
      : super(ThemeState(
          mode: CustomThemeMode.light,
          theme: AppTheme.lightTheme,
        ));

  void toggleTheme() {
    final currentMode = value.mode;
    final newMode = currentMode == CustomThemeMode.light ? CustomThemeMode.dark : CustomThemeMode.light;
    setTheme(newMode);
  }

  void setTheme(CustomThemeMode mode) {
    final newTheme = mode == CustomThemeMode.light
        ? AppTheme.lightTheme
        : AppTheme.darkTheme;

    value = value.copyWith(
      mode: mode,
      theme: newTheme,
    );
  }

  CustomThemeMode get currentMode => value.mode;
  ThemeData get currentTheme => value.theme;
  bool get isDarkMode => value.mode == CustomThemeMode.dark;
}
