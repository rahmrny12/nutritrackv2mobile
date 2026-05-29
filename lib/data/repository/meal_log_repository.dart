import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/models/meal_log_model.dart';

class MealLogRepository {
  final ApiService api;

  MealLogRepository(this.api);

  Future<List<MealLogModel>> fetchMealLogs({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final Map<String, dynamic> query = {};

    if (startDate != null) {
      query['start_date'] = startDate.toIso8601String().split('T').first;
    }

    if (endDate != null) {
      query['end_date'] = endDate.toIso8601String().split('T').first;
    }

    final res = await api.get('/meal-logs', query: query);

    if (res['statusCode'] != 200) {
      throw Exception(res['message'] ?? 'Data meal tidak ditemukan');
    }

    if (res['data'] == null || res['data'] is! List) {
      throw Exception('Data meal log belum ada');
    }

    final List<dynamic> data = res['data'] as List<dynamic>;

    return data
        .map((item) => MealLogModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<MealLogModel> createMealLogWithFoods({
    String? mealType,
    required List<Map<String, dynamic>> foods,
  }) async {
    final res = await api.post('/meal-logs', {
      'meal_type': mealType,
      'foods': foods,
    });

    if (res['statusCode'] != 201 && res['statusCode'] != 200) {
      throw Exception(res['message'] ?? 'Gagal menyimpan meal log');
    }

    final data = res['data'];

    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('Response meal log tidak valid');
    }

    return MealLogModel.fromJson(data);
  }
}
