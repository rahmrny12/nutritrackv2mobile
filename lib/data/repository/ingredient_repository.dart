import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/models/ingredient_model.dart';

class IngredientRepository {
  final ApiService api;

  IngredientRepository(this.api);

  Future<List<IngredientModel>> fetchIngredients() async {
    final res = await api.get('/ingredients');

    return (res as List).map((e) => IngredientModel.fromJson(e)).toList();
  }
}