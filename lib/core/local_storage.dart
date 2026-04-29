class LocalStorage {
  String? _token;

  Future<void> saveToken(String token) async {
    _token = token;
  }

  String? getToken() => _token;
}