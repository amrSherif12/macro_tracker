import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';
import 'package:testt/data/helpers/firestore/search_repository.dart';
import 'package:testt/data/models/consumable_model.dart';
import 'package:testt/data/models/filter_model.dart';
import 'package:testt/data/helpers/random.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchBarEmpty());

  String latestQuery = '';

  Future<void> search(String query, FilterModel filters) async {
    latestQuery = query;
    if (query.isNotEmpty) {
      emit(SearchLoading());
      List<ConsumableModel> consumables = [];
      try {
        consumables = await SearchRepository.instance.searchFood(
          query,
          filters,
        );
        List<String> saved = await FoodRepository.instance.getSaved(
          filters.isRecipe,
        );
        if (consumables.isNotEmpty) {
          if (latestQuery.isNotEmpty) {
            emit(SearchLoaded(consumables: consumables, saved: saved));
          } else {
            emit(SearchBarEmpty());
          }
        } else {
          emit(SearchNoMatch());
        }
      } catch (e) {
        if (!(await connectedToInternet())) {
          emit(SearchNoInternet());
        } else {
          emit(SearchError(errorMessage: e.toString()));
        }
      }
    } else {
      emit(SearchBarEmpty());
    }
  }
}
