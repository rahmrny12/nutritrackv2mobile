import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nutritrack/core/token_storage.dart';

class ApiService {
  final String baseUrl = "http://localhost:8000/api";

  // 🔹 COMMON HEADER
  Map<String, String> _headers({String? token}) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<Map<String, String>> _headersWithAuth() async {
    final token = await TokenStorage.getToken();
    
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // 🔹 POST
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl$path");

    try {
      final response = await http.post(
        url,
        headers: await _headersWithAuth(),
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw Exception(data['message'] ?? "Request gagal");
      }
    } catch (e) {
      throw Exception("POST Error: $e");
    }
  }

  // 🔹 GET (IMPROVED)
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final uri = Uri.parse("$baseUrl$path").replace(
      queryParameters: query?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    try {
      final response = await http.get(uri, headers: await _headersWithAuth());

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 🔥 handle Laravel API Resource
        if (data is Map && data.containsKey('data')) {
          return data['data'];
        }
        return data;
      } else {
        throw Exception(data['message'] ?? "Gagal mengambil data");
      }
    } catch (e) {
      throw Exception("GET Error: $e");
    }
  }
}
