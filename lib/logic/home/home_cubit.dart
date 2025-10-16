import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:testt/data/helpers/firestore/day_repository.dart';
import 'package:testt/data/models/day_model.dart';

import '../../data/models/consumable_model.dart';
import '../../presentation/widgets/toast.dart';
import '../../data/helpers/random.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());
  DateTime date = DateTime.now();
  late DayModel currentDay;

  Future<void> addFood(
    BuildContext context,
    DateTime date,
    String meal,
    ConsumableModel food,
  ) async {
    await DayRepository.instance.addFood(date, meal, food);
    toastBuilder('Added ${food.name} to $meal', context);
    await getDay(refresh: true);
  }

  Future<void> removeFood(
    BuildContext context,
    DateTime date,
    String meal,
    ConsumableModel food,
  ) async {
    if (meal.toLowerCase() == 'breakfast') {
      currentDay.breakfast.removeWhere(
        (consumable) => consumable.id == food.id,
      );
    } else if (meal.toLowerCase() == 'lunch') {
      currentDay.lunch.removeWhere((consumable) => consumable.id == food.id);
    } else if (meal.toLowerCase() == 'dinner') {
      currentDay.dinner.removeWhere((consumable) => consumable.id == food.id);
    } else if (meal.toLowerCase() == 'snacks') {
      currentDay.snacks.removeWhere((consumable) => consumable.id == food.id);
    }
    emit(HomeLoaded(day: currentDay, animate: true));
    await DayRepository.instance.removeFood(date, meal, food);
    toastBuilder('Removed ${food.name} from $meal', context);
    await getDay(refresh: true);
  }

  Future<void> incrementDay({required DayModel day}) async {
    try {
      date = day.date.add(const Duration(days: 1));
      getDay();
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(HomeNoInternet());
      } else {
        emit(HomeError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> decrementDay({required DayModel day}) async {
    try {
      date = day.date.subtract(const Duration(days: 1));
      getDay();
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(HomeNoInternet());
      } else {
        emit(HomeError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> changeDay({
    required DayModel day,
    required DateTime newDate,
  }) async {
    try {
      date = newDate;
      getDay();
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(HomeNoInternet());
      } else {
        emit(HomeError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> switchCheatDay(bool isFree, {required DayModel day}) async {
    try {
      currentDay.isFree = !currentDay.isFree;
      emit(HomeLoaded(day: currentDay, animate: true));
      DayRepository.instance.switchCheatDay(date, isFree);
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(HomeNoInternet());
      } else {
        emit(HomeError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> getDay({bool refresh = true}) async {
    if (refresh) {
      emit(HomeLoaded(day: currentDay, animate: false));
    } else {
      emit(HomeLoading());
    }
    try {
      DayModel day = await DayRepository.instance.getDay(date);
      currentDay = day;
      emit(HomeLoaded(day: day, animate: true));
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(HomeNoInternet());
      } else {
        emit(HomeError(errorMessage: e.toString()));
      }
    }
  }
}
