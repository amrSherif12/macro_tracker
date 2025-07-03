import 'package:bloc/bloc.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';
import 'package:meta/meta.dart';

import '../../data/models/food_model.dart';
import '../../random.dart';

part 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  FoodCubit() : super(FoodLoading());

  Future<void> getFood({bool? isRefresh}) async {
    if (isRefresh != true) emit(FoodLoading());
    List<FoodModel> food = await FoodRepository.instance.getFoods();

    try {
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
