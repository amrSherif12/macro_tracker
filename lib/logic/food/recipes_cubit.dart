import 'package:bloc/bloc.dart';
import 'package:macro_tracker_2/data/helpers/firestore/food_repository.dart';
import 'package:meta/meta.dart';

import '../../data/helpers/firestore/day_repository.dart';
import '../../data/models/recipe_model.dart';
import '../../utils.dart';

part 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  RecipesCubit() : super(RecipesLoading());

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
