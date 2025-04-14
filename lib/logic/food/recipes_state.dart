part of 'recipes_cubit.dart';

@immutable
abstract class RecipesState {}

class RecipesLoading extends RecipesState {}

class RecipesLoaded extends RecipesState {
  final List<RecipeModel> recipes;

  RecipesLoaded({required this.recipes});
}

class RecipesNoData extends RecipesState {}

class RecipesNoInternet extends RecipesState {}

class RecipesError extends RecipesState {
  String errorMessage;

  RecipesError({required this.errorMessage});
}
