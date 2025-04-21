import 'package:bloc/bloc.dart';
import 'package:macro_tracker_2/data/helpers/firestore/day_repository.dart';
import 'package:macro_tracker_2/data/helpers/firestore/food_repository.dart';
import 'package:macro_tracker_2/data/models/day_model.dart';
import 'package:meta/meta.dart';

import '../../utils.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  DateTime date = DateTime.now();

  Future<void> incrementDay({required DayModel day}) async {
    try {
      date = date.add(const Duration(days: 1));
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
      date = date.subtract(const Duration(days: 1));
      getDay(day: day);
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(HomeNoInternet());
      } else {
        emit(HomeError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> changeDay(
      {required DayModel day, required DateTime newDate}) async {
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
      await DayRepository.instance.switchCheatDay(date, isFree);
      getDay(day: day);
    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(HomeNoInternet());
      } else {
        emit(HomeError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> getDay({required DayModel? day}) async {
    if (day == null) {
      emit(HomeLoading());
    } else {
      emit(HomeLoaded(day: day, animate: false));
    }
    DayModel day1 = await DayRepository.instance.getDay(date);
    emit(HomeLoaded(day: day1, animate: true));
    try {

    } catch (e) {
      if (!(await connectedToInternet())) {
        emit(HomeNoInternet());
      } else {
        emit(HomeError(errorMessage: e.toString()));
      }
    }
  }
}
