import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_tracker_2/data/models/day_model.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:macro_tracker_2/data/models/recipe_model.dart';

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
        breakfastFood: [],
        breakfastRecipes: [],
        lunchFood: [],
        lunchRecipes: [],
        dinnerFood: [],
        dinnerRecipes: [],
        snacksFood: [],
        snacksRecipes: [],
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

  void addDayFoodOrRecipe(DateTime date, String meal,
      {FoodModel? food, RecipeModel? recipe}) async {
    if (!(await dateIsAdded(date))) {
      await addDay(date);
    }
    ins
        .collection("users")
        .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
        .collection('dairy')
        .doc('${date.day}-${date.month}-${date.year}')
        .update(
      {meal: food == null ? recipe!.toMap() : food.toMap()},
    );
  }

  Future<void> switchCheatDay(DateTime date, bool isFree) async {
    if (await dateIsAdded(date)) {
      await ins
          .collection("users")
          .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
          .collection('dairy')
          .doc('${date.day}-${date.month}-${date.year}')
          .update({'isFree': isFree});
    } else {}
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
          breakfastFood: [],
          breakfastRecipes: [],
          lunchFood: [],
          lunchRecipes: [],
          dinnerFood: [],
          dinnerRecipes: [],
          snacksFood: [],
          snacksRecipes: [],
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
