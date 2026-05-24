import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _key = 'auth_token';
  static const _profileKey = 'user_profile';
  static const _userKey = 'user_data';

  // ─────────────────────────────────────────────
  // SCREENING KEYS
  // ─────────────────────────────────────────────

  static const _goutScreeningKey = 'gout_screening_result';
  static const _diabetesScreeningKey = 'diabetes_screening_result';
  static const _heartScreeningKey = 'heart_screening_result';

  // ─────────────────────────────────────────────
  // AUTH
  // ─────────────────────────────────────────────

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveUser(
    Map<String, dynamic> user,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _userKey,
      jsonEncode(user),
    );
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_userKey);

    if (data == null) return null;

    return jsonDecode(data);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_key, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_key);
  }

  // ─────────────────────────────────────────────
  // PROFILE
  // ─────────────────────────────────────────────

  static Future<void> saveProfile(
    Map<String, dynamic> profile,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _profileKey,
      jsonEncode(profile),
    );
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_profileKey);

    if (data == null) return null;

    return jsonDecode(data);
  }

  // ─────────────────────────────────────────────
  // GOUT SCREENING
  // ─────────────────────────────────────────────

  static Future<void> saveGoutScreeningResult(
    Map<String, dynamic> result,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _goutScreeningKey,
      jsonEncode(result),
    );
  }

  static Future<Map<String, dynamic>?>
  getGoutScreeningResult() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_goutScreeningKey);

    if (data == null) return null;

    return jsonDecode(data);
  }

  // ─────────────────────────────────────────────
  // DIABETES SCREENING
  // ─────────────────────────────────────────────

  static Future<void> saveDiabetesScreeningResult(
    Map<String, dynamic> result,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _diabetesScreeningKey,
      jsonEncode(result),
    );
  }

  static Future<Map<String, dynamic>?>
  getDiabetesScreeningResult() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_diabetesScreeningKey);

    if (data == null) return null;

    return jsonDecode(data);
  }

  // ─────────────────────────────────────────────
  // HEART SCREENING
  // ─────────────────────────────────────────────

  static Future<void> saveHeartScreeningResult(
    Map<String, dynamic> result,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _heartScreeningKey,
      jsonEncode(result),
    );
  }

  static Future<Map<String, dynamic>?>
  getHeartScreeningResult() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_heartScreeningKey);

    if (data == null) return null;

    return jsonDecode(data);
  }

  // ─────────────────────────────────────────────
  // OPTIONAL CLEAR SCREENING
  // ─────────────────────────────────────────────

  static Future<void> clearScreeningResults() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_goutScreeningKey);
    await prefs.remove(_diabetesScreeningKey);
    await prefs.remove(_heartScreeningKey);
  }

  // ─────────────────────────────────────────────
  // CLEAR ALL
  // ─────────────────────────────────────────────

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
    await prefs.remove(_profileKey);
    await prefs.remove(_userKey);

    await prefs.remove(_goutScreeningKey);
    await prefs.remove(_diabetesScreeningKey);
    await prefs.remove(_heartScreeningKey);
  }
}