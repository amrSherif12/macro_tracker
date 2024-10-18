import 'package:bloc/bloc.dart';
import 'package:macro_tracker_2/data/helpers/firestore_helper.dart';
import 'package:meta/meta.dart';

import '../../data/models/food_model.dart';

part 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  FoodCubit() : super(FoodLoading());

  Future<void> getFood({bool? isRefresh}) async {
    if (isRefresh != true) emit(FoodLoading());
    if (await FireStoreHelper.instance.connectedToInternet()) {
      List<FoodModel> food = await FireStoreHelper.instance.getFoods();
      if (food.isEmpty) {
        emit(FoodNoData());
      } else {
        emit(FoodLoaded(food: food));
      }
    } else {
      emit(FoodNoInternet());
    }
  }
}
