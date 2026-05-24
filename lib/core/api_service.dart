import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:nutritrack/core/local_storage.dart';

class ApiService {
  // final String baseUrl = "https://nutritrack.web.id/api";
  final String baseUrl = "https://ef05-2402-8780-101a-30bc-4d41-8f5a-1de4-c23d.ngrok-free.app/api";

  // 🔹 COMMON HEADER
  Map<String, String> _headers({String? token}) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<Map<String, String>> _headersWithAuth() async {
    final token = await LocalStorage.getToken();

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

      return {"statusCode": response.statusCode, ...data};
    } catch (e) {
      throw Exception("POST Error: $e");
    }
  }

  Future<Map<String, dynamic>> get(
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

      return {"statusCode": response.statusCode, ...data};
    } catch (e) {
      throw Exception("GET Error: $e");
    }
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    Map<String, File>? files,
  }) async {
    final url = Uri.parse("$baseUrl$path");

    final request = http.MultipartRequest('POST', url);

    // headers (NO content-type JSON here!)
    final token = await LocalStorage.getToken();
    request.headers.addAll({
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    });

    // fields (text data)
    request.fields.addAll(fields);

    // files (image, etc)
    if (files != null) {
      for (final entry in files.entries) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value.path),
        );
      }
    }

    final streamedResponse = await request.send();
    final response = await streamedResponse.stream.bytesToString();

    final data = jsonDecode(response);

    if (streamedResponse.statusCode >= 200 &&
        streamedResponse.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['message'] ?? "Multipart request failed");
    }
  }
}
