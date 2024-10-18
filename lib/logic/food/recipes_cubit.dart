import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/helpers/firestore_helper.dart';
import '../../data/models/recipe_model.dart';

part 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  RecipesCubit() : super(RecipesLoading());

  Future<void> getRecipes({bool? isRefresh}) async {
    if (isRefresh != true) emit(RecipesLoading());
    if (await FireStoreHelper.instance.connectedToInternet()) {
      List<RecipeModel> recipes = await FireStoreHelper.instance.getRecipes();
      if (recipes.isEmpty) {
        emit(RecipesNoData());
      } else {
        emit(RecipesLoaded(recipes: recipes));
      }
    } else {
      emit(RecipesNoInternet());
    }
  }
}
