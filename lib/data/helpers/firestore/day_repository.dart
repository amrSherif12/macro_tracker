import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:macro_tracker_2/data/models/consumable_model.dart';
import 'package:macro_tracker_2/data/models/day_model.dart';
import 'package:macro_tracker_2/presentation/widgets/toast.dart';
import 'package:macro_tracker_2/utils.dart';

import '../auth_helper.dart';

class DayRepository {
  DayRepository._privateConstructor();

  static final DayRepository _instance = DayRepository._privateConstructor();

  static DayRepository get instance => _instance;
  final ins = FirebaseFirestore.instance;

  Future<DayModel> addDay(DateTime date) async {
    DayModel map = DayModel(
        date: date,
        kcalConsumed: 0,
        kcalGoal: 1000,
        kcalBurned: 0,
        proteinCons: 0,
        proteinGoal: 10,
        carbCons: 0,
        carbGoal: 10,
        fatCons: 0,
        fatGoal: 10,
        isFree: false,
        breakfast: [],
        lunch: [],
        dinner: [],
        snacks: [],
        exercises: []);
    await ins
        .collection("users")
        .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
        .collection('dairy')
        .doc('${date.day}-${date.month}-${date.year}')
        .set(map.toMap());
    return map;
  }

  Future<bool> dateIsAdded(DateTime date) async {
    DocumentSnapshot doc = await ins
        .collection("users")
        .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
        .collection('dairy')
        .doc('${date.day}-${date.month}-${date.year}')
        .get();
    return doc.exists;
  }

  Future<void> checkAndAddDay(DateTime date) async {
    if (!(await dateIsAdded(date))) {
      await addDay(date);
    }
  }

  void addFood(BuildContext context, DateTime date, String meal, ConsumableModel food) async {
    await checkAndAddDay(date);
    ins
        .collection("users")
        .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
        .collection('dairy')
        .doc('${date.day}-${date.month}-${date.year}')
        .set(
      {meal.toLowerCase(): {idGenerator(): food.toMap()}}, SetOptions(merge: true)
    );
    toastBuilder('Added ${food.name} to $meal', context);
  }

  Future<void> switchCheatDay(DateTime date, bool isFree) async {
    try {
      await ins
          .collection("users")
          .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
          .collection('dairy')
          .doc('${date.day}-${date.month}-${date.year}')
          .update({'isFree': isFree});
    } catch (e) {
      if (e.toString() ==
          '[cloud_firestore/not-found] Some requested document was not found.') {
        await addDay(date);
        switchCheatDay(date, isFree);
      }
    }
  }

  Future<DayModel> getDay(DateTime date) async {
    if (!(await dateIsAdded(date))) {
      return DayModel(
          date: date,
          kcalConsumed: 0,
          kcalGoal: 1000,
          kcalBurned: 0,
          proteinCons: 0,
          proteinGoal: 10,
          carbCons: 0,
          carbGoal: 10,
          fatCons: 0,
          fatGoal: 10,
          isFree: false,
          breakfast: [],
          lunch: [],
          dinner: [],
          snacks: [],
          exercises: []);
    } else {
      DayModel day = DayModel.fromMap(await ins
          .collection("users")
          .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
          .collection('dairy')
          .doc('${date.day}-${date.month}-${date.year}')
          .get());
      return day;
    }
  }
}
