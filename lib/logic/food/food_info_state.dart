part of 'food_info_cubit.dart';

@immutable
abstract class FoodInfoState {}

class FoodInfoLoading extends FoodInfoState {}

class FoodInfoLoaded extends FoodInfoState {
  final FoodInfoModel food;

  FoodInfoLoaded({required this.food});
}

class FoodInfoNoInternet extends FoodInfoState {}
