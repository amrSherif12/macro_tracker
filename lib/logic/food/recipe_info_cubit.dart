import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/helpers/firestore_helper.dart';
import '../../data/models/recipe_model.dart';

part 'recipe_info_state.dart';

class RecipeInfoCubit extends Cubit<RecipeInfoState> {
  RecipeInfoCubit() : super(RecipeInfoLoading());

  Future<void> getRecipe(String id) async {
    emit(RecipeInfoLoading());
    if (await FireStoreHelper.instance.connectedToInternet()) {
      RecipeInfoModel recipe = await FireStoreHelper.instance.getRecipe(id);
      emit(RecipeInfoLoaded(recipe: recipe));
    } else {
      emit(RecipeInfoNoInternet());
    }
  }
}
