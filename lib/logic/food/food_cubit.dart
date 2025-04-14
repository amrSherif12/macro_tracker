import 'package:bloc/bloc.dart';
import 'package:macro_tracker_2/data/helpers/firestore/food_repository.dart';
import 'package:meta/meta.dart';

import '../../data/models/food_model.dart';
import '../../utils.dart';

part 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  FoodCubit() : super(FoodLoading());

  Future<void> getFood({bool? isRefresh}) async {
    if (isRefresh != true) emit(FoodLoading());
    try {
      List<FoodModel> food = await FoodRepository.instance.getFoods();
      if (food.isEmpty) {
        emit(FoodNoData());
      } else {
        emit(FoodLoaded(food: food));
      }
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(FoodNoInternet());
      } else {
        emit(FoodError(errorMessage: e.toString()));
      }
    }
  }
}
