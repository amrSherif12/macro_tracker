part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoadingDay extends HomeState {}

class HomeLoaded extends HomeState {
  final DayModel day;
  final bool animate;

  HomeLoaded({required this.day, required this.animate});
}

class HomeNoInternet extends HomeState {}
