import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/models/recipe_model.dart';
import 'package:nutritrack/view/viewmodel/add_meal_state.dart';

class RecipeRepository {
  final ApiService api;

  RecipeRepository(this.api);

  Future<void> createRecipe({
    required String name,
    required bool isFavorite,
    required String desc,
    required List<RecipeIngredientItem> ingredients,
  }) async {
    final response = await api.post('/recipes', {
      'name': name,
      'is_favorite': isFavorite,
      'desc': desc,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
    });

    if (response == null) {
      throw Exception('Gagal membuat resep');
    }
  }

  Future<List<RecipeModel>> fetchRecipes() async {
    final response = await api.get('/recipes');

    final List data = response;

    return data.map((json) => RecipeModel.fromJson(json)).toList();
  }
}
