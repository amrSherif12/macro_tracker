part of 'food_cubit.dart';

@immutable
abstract class FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<FoodModel> food;

  FoodLoaded({required this.food});
}

class FoodNoData extends FoodState {}

class FoodNoInternet extends FoodState {}

class FoodError extends FoodState {
  String errorMessage;

  FoodError({required this.errorMessage});
}
