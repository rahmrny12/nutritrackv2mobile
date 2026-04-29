import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to post: ${response.statusCode} ${response.body}');
    }
  }
}