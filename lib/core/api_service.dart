class ApiService {
  Future<Map<String, dynamic>> post(String path, Map body) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API

    // 🔥 mock response
    if (body['email'] == 'admin' && body['password'] == '123') {
      return {
        "token": "abc123",
        "user": {"name": "Rahmat"}
      };
    } else {
      throw Exception("Login gagal");
    }
  }
}