import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:testt/data/helpers/firestore/day_repository.dart';
import 'package:testt/data/models/day_model.dart';

import '../../data/models/consumable_model.dart';
import '../../random.dart';

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
    await DayRepository.instance.addFood(context, date, meal, food);
    await getDay(refresh: true);
  }

  Future<void> incrementDay({required DayModel day}) async {
    try {
      date = day.date.add(const Duration(days: 1));
      getDay(day: day);
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
      getDay(day: day);
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
      getDay(day: day);
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

  Future<void> getDay({DayModel? day, bool refresh = false}) async {
    if (day == null) {
      emit(HomeLoading());
    } else if (!refresh) {
      emit(HomeLoaded(day: day, animate: false));
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
