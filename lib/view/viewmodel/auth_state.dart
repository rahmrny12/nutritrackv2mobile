import 'package:nutritrack/data/models/user_model.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final UserModel? user;
  final bool otpSuccess;
  final String? otpMessage;

  AuthState({
    this.isLoading = false,
    this.error,
    this.user,
    this.otpSuccess = false,
    this.otpMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    UserModel? user,
    bool? otpSuccess,
    String? otpMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
      otpSuccess: otpSuccess ?? this.otpSuccess,
      otpMessage: otpMessage ?? this.otpMessage,
    );
  }
}
