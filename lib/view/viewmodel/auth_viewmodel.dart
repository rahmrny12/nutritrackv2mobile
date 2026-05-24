import 'package:flutter/material.dart';
import 'package:nutritrack/data/repository/auth_repository.dart';
import 'package:nutritrack/view/viewmodel/auth_state.dart';

class AuthViewModel extends ValueNotifier<AuthState> {
  final AuthRepository repo;

  AuthViewModel({required this.repo}) : super(AuthState());

  final nameController = TextEditingController();
  final emailController = TextEditingController(
    text: "yeza@gmail.com"
  );
  final usernameController = TextEditingController();
  final passwordController = TextEditingController(
    text: "asdasdasd"
  );
  final passwordConfirmController = TextEditingController();
  final otpController = TextEditingController();

  Future<void> login() async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      final user = await repo.login(
        emailController.text,
        passwordController.text,
      );

      value = value.copyWith(isLoading: false, user: user);
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register() async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      final user = await repo.register(
        name: nameController.text,
        email: emailController.text,
        username: usernameController.text,
        passsword: passwordController.text,
        passwordConfirmation: passwordConfirmController.text,
      );

      value = value.copyWith(isLoading: false, user: user);
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> verifyOtp(String email) async {
    value = value.copyWith(isLoading: true, error: null, otpMessage: null, otpSuccess: false);

    try {
      final res = await repo.verifyOtp(
        email == "" ? null : email,
        otpController.text.trim(),
      );

      final msg = res['message']?.toString();
      final success = (res['success'] is bool) ? res['success'] as bool : (res['token'] != null);

      value = value.copyWith(isLoading: false, otpSuccess: success, otpMessage: msg);
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
    }
  }
}
