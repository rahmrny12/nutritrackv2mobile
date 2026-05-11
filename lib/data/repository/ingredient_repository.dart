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

    return (res as List).map((e) => IngredientModel.fromJson(e)).toList();
  }

  Future<List<IngredientModel>> searchIngredients(String query) async {
    final response = await api.get('/ingredients', query: {'search': query});

    return (response as List).map((e) => IngredientModel.fromJson(e)).toList();
  }

  Future<IngredientModel> createIngredient({
    required String name,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    final response = await api.post('/ingredients', {
      "name": name,
      "calories_per_100g": calories,
      "protein": protein,
      "carbs": carbs,
      "fat": fat,
    });

    final data = response['data']; // 👈 penting sesuai API kamu

    return IngredientModel.fromJson(data);
  }
}
