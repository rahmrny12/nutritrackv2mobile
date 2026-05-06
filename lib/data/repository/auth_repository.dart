import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/core/token_storage.dart';
import 'package:nutritrack/data/models/user_model.dart';

class AuthRepository {
  final ApiService api;

  AuthRepository(this.api);

  Future<UserModel> login(String email, String password) async {
    final res = await api.post('/login', {
      "email": email,
      "password": password,
    });

    final user = UserModel.fromJson(res);

    await TokenStorage.saveToken(user.token);

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

    return UserModel.fromJson(res);
  }
}
