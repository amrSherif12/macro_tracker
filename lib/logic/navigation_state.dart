part of 'navigation_cubit.dart';

@immutable
abstract class NavigationState {}

class NavigationUndefinedPage extends NavigationState {}

class NavigationHome extends NavigationState {}

class NavigationSearch extends NavigationState {}

class NavigationFood extends NavigationState {}

class NavigationExercise extends NavigationState {}
