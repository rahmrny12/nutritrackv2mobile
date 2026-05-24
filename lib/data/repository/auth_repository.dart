import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/core/local_storage.dart';
import 'package:nutritrack/data/models/user_model.dart';

class AuthRepository {
  final ApiService api;

  AuthRepository(this.api);

  Future<UserModel> login(String email, String password) async {
    final res = await api.post('/login', {
      "email": email,
      "password": password,
    });

    if (res['statusCode'] != 200) {
      throw Exception(res['message'] ?? 'User tidak ditemukan');
    }

    final user = UserModel.fromJson(res['data']);
    final token = user.token;

    await LocalStorage.saveToken(token ?? "");

    await LocalStorage.saveUser({"name": user.name, "email": user.email});

    return user;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String username,
    required String passsword,
    required String passwordConfirmation,
  }) async {
    final res = await api.post('/register', {
      "name": name,
      "email": email,
      "username": username,
      "password": passsword,
      "password_confirmation": passwordConfirmation,
    });

    if (res['statusCode'] != 200) {
      throw Exception(res['message'] ?? 'User gagal ditemukan');
    }

    final data = Map<String, dynamic>.from(res['data']);

    await LocalStorage.saveUser(Map<String, dynamic>.from(data));

    return UserModel.fromJson(data);
  }

  Future<Map<String, dynamic>> verifyOtp(String? email, String otp) async {
    final res = await api.post('/verify-otp', {
      "email": email == "" ? null : email,
      "otp": otp,
    });

    if (res['statusCode'] != 200) {
      throw Exception(res['message'] ?? 'Otp tidak valid');
    }

    // Normalize to Map
    final data = Map<String, dynamic>.from(res ?? {});

    // If API returns token and user, persist them locally
    if (data['token'] != null) {
      await LocalStorage.saveToken(data['token']);
    }

    return data;
  }

  Future<Map<String, dynamic>> resendOtp(String email) async {
    final response = await api.post('/email/resend', {"email": email});

    return response;
  }
}
