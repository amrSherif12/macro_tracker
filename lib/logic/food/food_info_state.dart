part of 'food_info_cubit.dart';

@immutable
abstract class FoodInfoState {}

class FoodInfoLoading extends FoodInfoState {}

class FoodInfoLoaded extends FoodInfoState {
  final FoodModel food;

  FoodInfoLoaded({required this.food});
}

class FoodInfoNoInternet extends FoodInfoState {}

class FoodInfoError extends FoodInfoState {
  String errorMessage;

  FoodInfoError({required this.errorMessage});
}
