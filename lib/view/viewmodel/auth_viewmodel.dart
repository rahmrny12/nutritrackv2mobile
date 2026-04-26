import 'package:flutter/material.dart';
import 'package:nutritrack/data/repository/auth_repository.dart';
import 'package:nutritrack/view/viewmodel/auth_state.dart';

class AuthViewModel extends ValueNotifier<AuthState> {
  final AuthRepository repo;

  AuthViewModel(this.repo) : super(AuthState());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      final user = await repo.login(
        emailController.text,
        passwordController.text,
      );

      value = value.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}