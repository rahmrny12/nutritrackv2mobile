import 'dart:io';

import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/models/ingredient_model.dart';

class IngredientRepository {
  final ApiService api;

  IngredientRepository(this.api);

  Future<List<IngredientModel>> fetchIngredients({String? type}) async {
    final res = await api.get(
      '/ingredients',
      query: {if (type != null) 'type': type},
    );

    if (res['statusCode'] != 200) {
      throw Exception(res['message'] ?? 'Data meal tidak ditemukan');
    }

    final List data = res['data'] ?? res;

    return data.map((json) => IngredientModel.fromJson(json)).toList();
  }

  Future<List<IngredientModel>> searchIngredients(String query) async {
    final res = await api.get('/ingredients', query: {'search': query});

    final List data = res['data'] ?? res;

    return data.map((json) => IngredientModel.fromJson(json)).toList();
  }

  Future<IngredientModel> createIngredient({
    required String name,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    File? imageFile,
  }) async {
    final res = await api.postMultipart(
      '/ingredients',
      fields: {
        "name": name,
        "calories_per_100g": calories.toString(),
        "protein": protein.toString(),
        "carbs": carbs.toString(),
        "fat": fat.toString(),
      },
      files: imageFile != null ? {"image": imageFile} : null,
    );

    return IngredientModel.fromJson(res['data']);
  }
}
