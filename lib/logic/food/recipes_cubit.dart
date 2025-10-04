import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';

import '../../data/models/food_model.dart';
import '../../data/models/recipe_model.dart';
import '../../presentation/widgets/toast.dart';
import '../../data/helpers/random.dart';

part 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  RecipesCubit() : super(RecipesLoading());

  Future<void> addRecipe(
    BuildContext context,
    String name,
    String description,
    List<FoodModel> foods,
    List<TextEditingController> amounts, {
    String? id,
  }) async {
    try {
      List<Map> ingredients = [];
      for (int i = 0; i < foods.length; i++) {
        ingredients.add({
          'name': foods[i].name,
          'kcal': foods[i].kcal,
          'protein': foods[i].protein,
          'carb': foods[i].carb,
          'fat': foods[i].fat,
          'unit': foods[i].unit,
          'amount': double.parse(amounts[i].text),
        });
      }
      RecipeModel newRecipe = await FoodRepository.instance.addRecipe(
        name,
        description,
        ingredients,
        amounts,
        id: id,
      );
      toastBuilder('Recipe ${id == null ? "created" : "updated"}', context);
      if (state is RecipesNoData) {
        emit(RecipesLoaded(recipes: [newRecipe]));
        return;
      }
      final stateLoaded = state as RecipesLoaded;
      if (id == null) {
        stateLoaded.recipes.add(newRecipe);
      } else {
        int index = stateLoaded.recipes.indexWhere(
          (recipe_) => recipe_.id == id,
        );
        newRecipe.recalculateMacros();
        stateLoaded.recipes[index] = newRecipe;
      }
      emit(RecipesLoaded(recipes: stateLoaded.recipes));
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(RecipesNoInternet());
      } else {
        emit(RecipesError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> updateRecipeAmounts(
    BuildContext context,
    RecipeModel recipe,
    List<TextEditingController> amounts,
  ) async {
    try {
      await FoodRepository.instance.updateRecipeAmounts(
        recipe,
        amounts,
      );
      toastBuilder('Recipes updated', context);
      final stateLoaded = state as RecipesLoaded;
      int index = stateLoaded.recipes.indexWhere(
        (recipe_) => recipe_.id == recipe.id,
      );
      stateLoaded.recipes[index] = recipe;
      emit(RecipesLoaded(recipes: stateLoaded.recipes));
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(RecipesNoInternet());
      } else {
        emit(RecipesError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> deleteRecipe(BuildContext context, String id) async {
    try {
      await FoodRepository.instance.deleteFood(id, isRecipe: true);
      toastBuilder('Recipe deleted', context);
      final stateLoaded = state as RecipesLoaded;
      stateLoaded.recipes.removeWhere((recipe) => recipe.id == id);
      emit(RecipesLoaded(recipes: stateLoaded.recipes));
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(RecipesNoInternet());
      } else {
        emit(RecipesError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> getRecipes({bool? isRefresh}) async {
    if (isRefresh != true) emit(RecipesLoading());
    try {
      List<RecipeModel> recipes = [];
      List<String> recipesIds = await FoodRepository.instance.getSaved(true);
      for (int i = 0; i < ((recipesIds.length.toDouble()) / 30).ceil(); i++) {
        List sub = [];
        if (i < ((recipesIds.length.toDouble()) / 30).ceil() - 1) {
          sub = recipesIds.sublist(0 + (i * 30), 30 + (i * 30));
        } else {
          sub = recipesIds.sublist(0 + (i * 30), recipesIds.length);
        }
        recipes = await FoodRepository.instance.getRecipes(sub);
      }
      if (recipes.isEmpty) {
        emit(RecipesNoData());
      } else {
        emit(RecipesLoaded(recipes: recipes));
      }
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(RecipesNoInternet());
      } else {
        emit(RecipesError(errorMessage: e.toString()));
      }
    }
  }
}
