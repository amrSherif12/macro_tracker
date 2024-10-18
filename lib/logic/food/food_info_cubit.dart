import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:macro_tracker_2/data/helpers/firestore_helper.dart';
import 'package:macro_tracker_2/presentation/widgets/toast.dart';
import 'package:meta/meta.dart';

import '../../data/models/food_model.dart';

part 'food_info_state.dart';

class FoodInfoCubit extends Cubit<FoodInfoState> {
  FoodInfoCubit() : super(FoodInfoLoading());

  Future<void> getFood(String id) async {
    emit(FoodInfoLoading());
    if (await FireStoreHelper.instance.connectedToInternet()) {
      FoodInfoModel food = await FireStoreHelper.instance.getFood(id);
      emit(FoodInfoLoaded(food: food));
    } else {
      emit(FoodInfoNoInternet());
    }
  }

  Future<void> saveFood(BuildContext context, FoodInfoModel food) async {
    if (food.kcal > 1000) {
      toastBuilder('Food can\'t exceed 1000 kcal', context);
    }
    if (food.protein * 4 + food.carb * 4 + food.fat * 9 > food.kcal) {
      toastBuilder(
          'Macro nutrients are exceeding the calories in the food', context);
    } else {
      await FireStoreHelper.instance.updateFood(context, food);
      Navigator.pop(context);
    }
  }
}
