import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';

import '../../data/helpers/firestore/day_repository.dart';
import '../../data/models/food_model.dart';
import '../../data/models/recipe_model.dart';
import '../../random.dart';

part 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  RecipesCubit() : super(RecipesLoading());

  Future<void> addRecipe(
    BuildContext context,
    String name,
    String description,
    List<FoodModel> foods,
    List<TextEditingController> amounts,
  ) async {
    await FoodRepository.instance.addRecipe(context, name, description, foods, amounts);
    await getRecipes(isRefresh: true);
  }

  Future<void> updateRecipeAmounts(BuildContext context, RecipeModel recipe, List<TextEditingController> amounts,) async {
    await FoodRepository.instance.updateRecipeAmounts(context, recipe, amounts);
    await getRecipes(isRefresh: true);
  }

  Future<void> deleteRecipe(BuildContext context, String id) async {
    await FoodRepository.instance.deleteFood(context, id, isRecipe: true);
    await getRecipes(isRefresh: true);
  }

  Future<void> getRecipes({bool? isRefresh}) async {
    if (isRefresh != true) emit(RecipesLoading());
    try {
      List<RecipeModel> recipes = await FoodRepository.instance.getRecipes();
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
