import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/models/user_model.dart';

class AuthRepository {
  final ApiService api;

  AuthRepository(this.api);

  Future<UserModel> login(String email, String password) async {
    final res = await api.post('/login', {
      "email": email,
      "password": password,
    });

    return UserModel.fromJson(res);
  }
}