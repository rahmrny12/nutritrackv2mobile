// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:nutritrack/data/models/ingredient_model.dart';
import 'package:nutritrack/data/models/recipe_model.dart';
import 'package:nutritrack/data/repository/ingredient_repository.dart';
import 'package:nutritrack/data/repository/recipe_repository.dart';
import 'package:nutritrack/view/viewmodel/log_food_state.dart';

class LogFoodViewModel extends ValueNotifier<LogFoodState> {
  final IngredientRepository ingredientRepo;
  final RecipeRepository recipeRepo;

  LogFoodViewModel({required this.ingredientRepo, required this.recipeRepo})
    : super(LogFoodState());

  Future<void> fetchIngredients() async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      final data = await ingredientRepo.fetchIngredients();

      value = value.copyWith(isLoading: false, ingredients: data);
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchRecipes() async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      final data = await recipeRepo.fetchRecipes();

      value = value.copyWith(isLoading: false, recipes: data);
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createIngredient(IngredientModel ingredient) async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      final newIngredient = await ingredientRepo.createIngredient(
        name: ingredient.name,
        calories: ingredient.caloriesPer100g,
        protein: ingredient.protein,
        carbs: ingredient.carbs,
        fat: ingredient.fat,
      );

      value = value.copyWith(
        isLoading: false,
        ingredients: [newIngredient, ...value.ingredients],
      );
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchByTab(int tabIndex) async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      if (tabIndex == 2) {
        final recipes = await recipeRepo.fetchRecipes();

        value = value.copyWith(
          tab: LogFoodTabType.recipe,
          recipes: recipes,
          ingredients: [],
          isLoading: false,
        );
        return;
      }
      final data = await ingredientRepo.fetchIngredients();

      value = value.copyWith(
        tab: LogFoodTabType.ingredient,
        ingredients: data,
        recipes: [],
        isLoading: false,
      );
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Tambah makanan ke selected foods
  void addSelectedFood(IngredientModel food) {
    final updated = [...value.selectedFoods, food];
    value = value.copyWith(selectedFoods: updated);
  }

  /// Hapus makanan dari selected foods
  void removeSelectedFood(int foodId) {
    final updated = value.selectedFoods
        .where((food) => food.id != foodId)
        .toList();
    value = value.copyWith(selectedFoods: updated);
  }

  /// Toggle makanan (tambah/hapus)
  void toggleSelectedFood(IngredientModel food) {
    final exists = value.selectedFoods.any((f) => f.id == food.id);
    if (exists) {
      removeSelectedFood(food.id);
    } else {
      addSelectedFood(food);
    }
  }

  /// Check apakah food sudah dipilih
  bool isFoodSelected(int foodId) {
    return value.selectedFoods.any((food) => food.id == foodId);
  }

  /// Clear semua selected foods
  void clearSelectedFoods() {
    value = value.copyWith(selectedFoods: []);
  }

  void setTab(LogFoodTabType tab) {
    value = value.copyWith(tab: tab);

    if (tab == LogFoodTabType.ingredient) {
      fetchIngredients();
    } else {
      fetchRecipes();
    }
  }

  void selectRecipe(RecipeModel recipe) {
    final exists = value.selectedRecipes.any((r) => r.id == recipe.id);

    if (exists) {
      final updated = value.selectedRecipes
          .where((r) => r.id != recipe.id)
          .toList();

      value = value.copyWith(selectedRecipes: updated);
    } else {
      value = value.copyWith(
        selectedRecipes: [...value.selectedRecipes, recipe],
      );
    }
  }

  void toggleRecipe(RecipeModel recipe) {
    final exists = value.selectedRecipes.any((r) => r.id == recipe.id);

    if (exists) {
      final updated = value.selectedRecipes
          .where((r) => r.id != recipe.id)
          .toList();

      value = value.copyWith(selectedRecipes: updated);
    } else {
      value = value.copyWith(
        selectedRecipes: [...value.selectedRecipes, recipe],
      );
    }
  }

  bool isRecipeSelected(int recipeId) {
    return value.selectedRecipes.any((r) => r.id == recipeId);
  }
}
