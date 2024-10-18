part of 'recipe_info_cubit.dart';

@immutable
abstract class RecipeInfoState {}

class RecipeInfoLoaded extends RecipeInfoState {
  final RecipeInfoModel recipe;

  RecipeInfoLoaded({required this.recipe});
}

class RecipeInfoLoading extends RecipeInfoState {}

class RecipeInfoNoInternet extends RecipeInfoState {}
