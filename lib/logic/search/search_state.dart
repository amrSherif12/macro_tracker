part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchBarEmpty extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ConsumableModel> consumables;
  final List<String> saved;

  SearchLoaded({required this.consumables, required this.saved});
}

class SearchNoMatch extends SearchState {}

class SearchNoInternet extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final String errorMessage;

  SearchError({required this.errorMessage});
}
