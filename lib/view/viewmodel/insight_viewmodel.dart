// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/core/local_storage.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/repository/meal_log_repository.dart';
import 'package:nutritrack/view/viewmodel/insight_state.dart';

class InsightViewModel extends ValueNotifier<InsightState> {
  late final MealLogRepository _mealLogRepo;
  late final GenerativeModel _model;

  InsightViewModel({MealLogRepository? mealLogRepo}) : super(InsightState()) {
    _mealLogRepo = mealLogRepo ?? MealLogRepository(ApiService());
    _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
  }

  /// Get user profile from local storage
  Future<Map<String, dynamic>?> _getProfile() async {
    return await LocalStorage.getProfile();
  }

  /// Build profile description for AI analysis
  String _buildProfileDescription(Map<String, dynamic>? profile) {
    if (profile == null) {
      return 'No stored user profile is available. Use general healthy muscle gain recommendations.';
    }

    final usia = profile['usia'];
    final jenisKelamin = profile['jenis_kelamin'];
    final tinggiBadan = profile['tinggi_badan'];
    final beratBadan = profile['berat_badan'];
    final bmi = profile['bmi'];
    final lingkarPinggang = profile['lingkar_pinggang'];

    final details = <String>[];

    if (usia != null) {
      details.add('Age: $usia');
    }
    if (jenisKelamin != null) {
      details.add('Gender: $jenisKelamin');
    }
    if (tinggiBadan != null) {
      details.add('Height: ${tinggiBadan} cm');
    }
    if (beratBadan != null) {
      details.add('Weight: ${beratBadan} kg');
    }
    if (bmi != null) {
      details.add('BMI: ${bmi}');
    }
    if (lingkarPinggang != null) {
      details.add('Waist circumference: ${lingkarPinggang} cm');
    }

    if (details.isEmpty) {
      return 'The user has a profile stored, but no detailed preference values are available.';
    }

    return 'User profile details: ${details.join(', ')}.';
  }

  /// Fetch weekly nutrition insights and recommendations
  Future<void> fetchWeeklyInsights() async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      final weeklyData = await _getWeeklyRecommendations();

      value = value.copyWith(
        isLoading: false,
        weeklyData: weeklyData,
        message: 'Insight berhasil dimuat',
        error: null,
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        error: e.toString(),
        message: null,
      );
    }
  }

  /// Get weekly nutrition analysis and AI-powered recommendations
  Future<Map<String, dynamic>> _getWeeklyRecommendations() async {
    try {
      // Fetch 7-day meal history
      final mealLogs = await _mealLogRepo.fetchMealLogs();

      // Get user profile for context
      final profile = await _getProfile();

      // Calculate weekly statistics
      double totalCalories = 0;
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFat = 0;
      int daysTracked = 0;

      // Group meals by day and calculate totals
      final Map<String, List<dynamic>> mealsByDay = {};

      for (final log in mealLogs) {
        totalCalories += log.totalCalories;

        // Calculate macros from food logs
        for (final food in log.foodLogs) {
          if (food.ingredient != null) {
            final qty = (food.quantity / 100.0);
            totalProtein += food.ingredient!.protein * qty;
            totalCarbs += food.ingredient!.carbs * qty;
            totalFat += food.ingredient!.fat * qty;
          }
        }

        final dateKey = log.createdAt.toString().split(' ')[0];
        mealsByDay.putIfAbsent(dateKey, () => []).add(log);
      }

      daysTracked = mealsByDay.length;

      // Calculate averages per day
      final avgCalories = daysTracked > 0 ? totalCalories / daysTracked : 0;
      final avgProtein = daysTracked > 0 ? totalProtein / daysTracked : 0;
      final avgCarbs = daysTracked > 0 ? totalCarbs / daysTracked : 0;
      final avgFat = daysTracked > 0 ? totalFat / daysTracked : 0;

      // Build AI prompt for analysis
      final profileDescription = _buildProfileDescription(profile);
      final analysisPrompt =
          """
Kamu adalah AI nutrisi profesional namun ramah.

Instruksi Output (WAJIB DIPATUHI):
1. Jawaban HANYA berupa JSON valid.
2. Tidak boleh JSON dalam bentuk string.
3. Tidak boleh menggunakan markdown (tidak ada \`\`\`).
4. Tidak boleh ada teks sebelum '{' atau sesudah '}'.
5. Nada penulisan positif, suportif, dan memotivasi.
6. Jika data pengguna rendah/kurang lengkap, tetap beri dukungan & dorongan tanpa menghakimi.
7. Hindari teks terlalu panjang, lebih baik ringkas, tapi tetap informatif.

Analisis data pengguna 7 hari terakhir:
- Total kalori: $totalCalories kcal
- Rata-rata kalori per hari: ${avgCalories.toStringAsFixed(1)} kcal
- Total protein: $totalProtein g
- Rata-rata protein per hari: ${avgProtein.toStringAsFixed(1)} g
- Total karbohidrat: $totalCarbs g
- Rata-rata karbohidrat per hari: ${avgCarbs.toStringAsFixed(1)} g
- Total lemak: $totalFat g
- Rata-rata lemak per hari: ${avgFat.toStringAsFixed(1)} g
- Hari tercatat: $daysTracked hari

Profil pengguna:
$profileDescription

Format JSON WAJIB:
{
  "rekomendasi": [
    "Rekomendasi spesifik dan actionable"
  ]
}

Mulai jawabanmu LANGSUNG dengan '{'. TIDAK ada teks sebelumnya.
""";

      final response = await _model.generateContent([
        Content.text(analysisPrompt),
      ]);

      final responseText = response.text ?? '{}';

      // Parse JSON response
      try {
        final jsonData = jsonDecode(responseText);
        return jsonData as Map<String, dynamic>;
      } catch (e) {
        // If parsing fails, return a default response
        return {
          'rekomendasi': [
            'Pola makan Anda menunjukkan perkembangan yang positif dalam beberapa hari terakhir',
            'Pertahankan konsumsi makanan bernutrisi untuk hasil kesehatan yang lebih optimal',
          ],
        };
      }
    } catch (e) {
      // Return error response
      return {
        'rekomendasi': [
          'Pola makan Anda menunjukkan perkembangan yang positif dalam beberapa hari terakhir',
          'Pertahankan konsumsi makanan bernutrisi untuk hasil kesehatan yang lebih optimal',
        ],
      };
    }
  }

  /// Clear insights data
  void clearInsights() {
    value = InsightState();
  }

  /// Dismiss error message
  void dismissError() {
    value = value.copyWith(error: null);
  }
}
