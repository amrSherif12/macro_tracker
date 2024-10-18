import 'package:bloc/bloc.dart';
import 'package:macro_tracker_2/data/models/day_model.dart';
import 'package:meta/meta.dart';

import '../../data/helpers/firestore_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  DateTime date = DateTime.now();

  Future<void> incrementDay({required DayModel day}) async {
    if (await FireStoreHelper.instance.connectedToInternet()) {
      date = date.add(const Duration(days: 1));
      getDay(day: day);
    } else {
      emit(HomeNoInternet());
    }
  }

  Future<void> decrementDay({required DayModel day}) async {
    if (await FireStoreHelper.instance.connectedToInternet()) {
      date = date.subtract(const Duration(days: 1));
      getDay(day: day);
    } else {
      emit(HomeNoInternet());
    }
  }

  Future<void> switchCheatDay(bool isFree, {required DayModel day}) async {
    if (await FireStoreHelper.instance.connectedToInternet()) {
      await FireStoreHelper.instance.switchCheatDay(date, isFree);
      getDay(day: day);
    } else {
      emit(HomeNoInternet());
    }
  }

  Future<void> getDay({required DayModel? day}) async {
    if (day == null) {
      emit(HomeLoading());
    } else {
      emit(HomeLoaded(day: day, animate: false));
    }
    if (await FireStoreHelper.instance.connectedToInternet()) {
      DayModel day = await FireStoreHelper.instance.getDay(date);
      emit(HomeLoaded(day: day, animate: true));
    } else {
      emit(HomeNoInternet());
    }
  }
}
