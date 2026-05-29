class RecipeIngredientItem {
  final int ingredientId;
  final String name;
  final int kcal;
  final String protein;
  final String karbo;
  final int gram;

  RecipeIngredientItem({
    required this.ingredientId,
    required this.name,
    required this.kcal,
    required this.protein,
    required this.karbo,
    required this.gram,
  });

  RecipeIngredientItem copyWith({
    int? gram,
  }) {
    return RecipeIngredientItem(
      ingredientId: ingredientId,
      name: name,
      kcal: kcal,
      protein: protein,
      karbo: karbo,
      gram: gram ?? this.gram,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredient_id': ingredientId,
      'quantity_gram': gram,
    };
  }
}

class MealState {
  final String name;
  final String description;
  final int selectedCategory;
  final bool isFavorite;
  final List<RecipeIngredientItem> ingredients;
  final List<RecipeIngredientItem> allIngredients; // Store all ingredients for search
  final String searchQuery;
  final bool isLoading;
  final bool isLoadingIngredients;
  final String? error;
  final bool success;

  MealState({
    this.name = '',
    this.description = '',
    this.selectedCategory = 0,
    this.isFavorite = true,
    this.ingredients = const [],
    this.allIngredients = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.isLoadingIngredients = false,
    this.error,
    this.success = false,
  });

  int get totalKcal =>
      ingredients.fold(0, (sum, item) => sum + item.kcal);

  MealState copyWith({
    String? name,
    String? description,
    int? selectedCategory,
    bool? isFavorite,
    List<RecipeIngredientItem>? ingredients,
    List<RecipeIngredientItem>? allIngredients,
    String? searchQuery,
    bool? isLoading,
    bool? isLoadingIngredients,
    String? error,
    bool? success,
  }) {
    return MealState(
      name: name ?? this.name,
      description: description ?? this.description,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isFavorite: isFavorite ?? this.isFavorite,
      ingredients: ingredients ?? this.ingredients,
      allIngredients: allIngredients ?? this.allIngredients,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isLoadingIngredients: isLoadingIngredients ?? this.isLoadingIngredients,
      error: error,
      success: success ?? this.success,
    );
  }
}
