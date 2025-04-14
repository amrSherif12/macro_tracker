import 'package:bloc/bloc.dart';
import 'package:macro_tracker_2/data/helpers/firestore/food_repository.dart';
import 'package:meta/meta.dart';

import '../../data/models/recipe_model.dart';
import '../../utils.dart';

part 'recipe_info_state.dart';

class RecipeInfoCubit extends Cubit<RecipeInfoState> {
  RecipeInfoCubit() : super(RecipeInfoLoading());

  Future<void> getRecipe(String id) async {
    emit(RecipeInfoLoading());
    try {
      RecipeModel recipe = await FoodRepository.instance.getRecipe(id);
      emit(RecipeInfoLoaded(recipe: recipe));
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(RecipeInfoNoInternet());
      } else {
        emit(RecipeInfoError(errorMessage: e.toString()));
      }
    }
  }
}
