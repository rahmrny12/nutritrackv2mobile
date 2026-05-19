import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/models/recipe_model.dart';
import 'package:nutritrack/view/viewmodel/add_meal_state.dart';

class RecipeRepository {
  final ApiService api;

  RecipeRepository(this.api);

  Future<RecipeModel> createRecipe({
    required String name,
    required bool isFavorite,
    required String desc,
    required List<RecipeIngredientItem> ingredients,
  }) async {
    final res = await api.post('/recipes', {
      'name': name,
      'is_favorite': isFavorite,
      'desc': desc,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
    });

    final data = res['data'];

    return RecipeModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<RecipeModel>> fetchRecipes() async {
    final res = await api.get('/recipes');

    final List data = res['data'] ?? res;

    return data.map((json) => RecipeModel.fromJson(json)).toList();
  }
}
