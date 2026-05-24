import 'package:flutter/material.dart';

enum CustomThemeMode { light, dark }

class ThemeState {
  final CustomThemeMode mode;
  final ThemeData theme;

  ThemeState({
    this.mode = CustomThemeMode.light,
    required this.theme,
  });

  ThemeState copyWith({
    CustomThemeMode? mode,
    ThemeData? theme,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      theme: theme ?? this.theme,
    );
  }
}
