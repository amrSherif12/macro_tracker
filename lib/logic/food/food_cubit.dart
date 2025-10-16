import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';

import '../../data/helpers/random.dart';
import '../../data/models/food_model.dart';
import '../../presentation/widgets/toast.dart';

part 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  FoodCubit() : super(FoodLoading());

  Future<void> addFood(BuildContext context, FoodModel food) async {
    try {
      FoodModel newFood = await FoodRepository.instance.addFood(food);
      toastBuilder('Food created', context);
      if (state is FoodNoData) {
        emit(FoodLoaded(food: [newFood]));
        return;
      }
      final stateLoaded = state as FoodLoaded;
      stateLoaded.food.add(newFood);
      emit(FoodLoaded(food: stateLoaded.food));
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(FoodNoInternet());
      } else {
        emit(FoodError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> updateFood(BuildContext context, FoodModel food) async {
    try {
      await FoodRepository.instance.updateFood(food);
      toastBuilder('Food updated', context);
      final stateLoaded = state as FoodLoaded;
      int index = stateLoaded.food.indexWhere((food_) => food_.id == food.id);
      stateLoaded.food[index] = food;
      emit(FoodLoaded(food: stateLoaded.food));
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(FoodNoInternet());
      } else {
        emit(FoodError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> deleteFood(
    BuildContext context,
    String id, {
    bool unSave = false,
  }) async {
    try {
      FoodRepository.instance.deleteFood(id);
      if (!unSave) toastBuilder('Food deleted', context);
      final stateLoaded = state as FoodLoaded;
      stateLoaded.food.removeWhere((food) => food.id == id);
      if (stateLoaded.food.isEmpty) {
        emit(FoodNoData());
      } else {
        emit(FoodLoaded(food: stateLoaded.food));
      }
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(FoodNoInternet());
      } else {
        emit(FoodError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> getFood({bool? isRefresh}) async {
    if (isRefresh != true) emit(FoodLoading());
    try {
      List<FoodModel> food = [];
      List<String> foodsIds = await FoodRepository.instance.getSaved(false);
      for (int i = 0; i < ((foodsIds.length.toDouble()) / 30).ceil(); i++) {
        List sub = [];
        if (i < ((foodsIds.length.toDouble()) / 30).ceil() - 1) {
          sub = foodsIds.sublist(0 + (i * 30), 30 + (i * 30));
        } else {
          sub = foodsIds.sublist(0 + (i * 30), foodsIds.length);
        }
        food = await FoodRepository.instance.getFoods(sub);
      }
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

  Future<void> saveFood(FoodModel food) async {
    try {
      await FoodRepository.instance.saveFood(food.id!);
      if (state is FoodNoData) {
        emit(FoodLoaded(food: [food]));
        return;
      }
      final stateLoaded = state as FoodLoaded;
      stateLoaded.food.add(food);
      emit(FoodLoaded(food: stateLoaded.food));
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(FoodNoInternet());
      } else {
        emit(FoodError(errorMessage: e.toString()));
      }
    }
  }
}
