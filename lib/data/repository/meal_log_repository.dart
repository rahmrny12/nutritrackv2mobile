import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/models/meal_log_model.dart';

class MealLogRepository {
  final ApiService api;

  MealLogRepository(this.api);

  Future<Map<String, dynamic>> createMealLog({required String mealType}) async {
    return await api.post('/meal-logs', {'meal_type': mealType});
  }

  Future<Map<String, dynamic>> addFood({
    required int mealLogId,
    required String type,
    int? ingredientId,
    int? recipeId,
    required int quantity,
  }) async {
    final body = <String, dynamic>{'type': type, 'quantity': quantity};

    if (ingredientId != null) {
      body['ingredient_id'] = ingredientId;
    }

    if (recipeId != null) {
      body['recipe_id'] = recipeId;
    }

    return await api.post('/meal-logs/$mealLogId/add-food', body);
  }

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
}
