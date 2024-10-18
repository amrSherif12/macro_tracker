import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:macro_tracker_2/data/models/day_model.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:macro_tracker_2/data/models/recipe_model.dart';
import 'package:macro_tracker_2/presentation/screens/food/food.dart';
import 'package:macro_tracker_2/presentation/widgets/toast.dart';
import 'package:macro_tracker_2/utils.dart';

import 'auth_helper.dart';

class FireStoreHelper {
  FireStoreHelper._privateConstructor();

  static final FireStoreHelper _instance =
      FireStoreHelper._privateConstructor();

  static FireStoreHelper get instance => _instance;
  final ins = FirebaseFirestore.instance;

  Future<bool> connectedToInternet() async {
    bool connected;
    connected = await InternetConnectionChecker().hasConnection;
    return connected;
  }

  void addFood(BuildContext context, FoodInfoModel food) async {
    food.id = idGenerator();
    ins.collection("food").add(food.toMap_());
    toastBuilder('Food created', context);
  }

  Future<void> updateFood(BuildContext context, FoodInfoModel food) async {
    await ins.collection("food").doc(food.id!).set(food.toMap_());
    toastBuilder('Food updated', context);
  }

  Future<FoodInfoModel> getFood(String id) async {
    FoodInfoModel food =
        FoodInfoModel.fromMap(await ins.collection("food").doc(id).get());
    return food;
  }

  Future<List<FoodModel>> getFoods() async {
    final uid = AuthenticationHelper.instance.auth.currentUser!.uid;
    List<FoodModel> foods = [];
    QuerySnapshot snapshot =
        await ins.collection("food").where('uid', isEqualTo: uid).get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      foods.add(FoodModel.fromMap(snapshot.docs[i]));
    }
    return foods;
  }

  Future<void> addRecipe(BuildContext context, String name, List<FoodModel> ids,
      List<TextEditingController> amounts) async {
    List<FoodInfoModel> foods = [];
    List<double> amountsDouble = [];
    int kcal = 0;
    double protein = 0;
    double carb = 0;
    double fat = 0;

    for (int i = 0; i < ids.length; i++) {
      foods.add(await FireStoreHelper.instance.getFood(ids[i].id!));
      amountsDouble.add(double.parse(amounts[i].text));
      for (int i = 0; i < foods.length; i++) {
        if (foods[i].unit == 'per piece' ||
            foods[i].unit == 'per table spoon') {
          kcal += (foods[i].kcal * amountsDouble[i]).toInt();
          protein += foods[i].protein * amountsDouble[i];
          carb += foods[i].carb * amountsDouble[i];
          fat += foods[i].fat * amountsDouble[i];
        } else {
          kcal += (foods[i].kcal * amountsDouble[i] / 100).toInt();
          protein += foods[i].protein * amountsDouble[i] / 100;
          carb += foods[i].carb * amountsDouble[i] / 100;
          fat += foods[i].fat * amountsDouble[i] / 100;
        }
      }
    }

    RecipeInfoModel recipe = RecipeInfoModel(
        uid: AuthenticationHelper.instance.auth.currentUser!.uid,
        recipe: name,
        kcal: kcal,
        ingredients: foods,
        amounts: amountsDouble,
        protein: protein,
        carb: carb,
        fat: fat);
    await ins.collection("recipes").add(recipe.toMap_());
    toastBuilder('Recipe created', context);
  }

  Future<void> updateRecipe(
      BuildContext context, RecipeInfoModel recipe) async {
    await ins.collection("recipes").doc(recipe.id!).set(recipe.toMap_());
    toastBuilder('Recipes updated', context);
  }

  Future<RecipeInfoModel> getRecipe(String id) async {
    RecipeInfoModel recipe =
        RecipeInfoModel.fromMap(await ins.collection("recipes").doc(id).get());
    return recipe;
  }

  Future<List<RecipeModel>> getRecipes() async {
    final uid = AuthenticationHelper.instance.auth.currentUser!.uid;
    List<RecipeModel> recipes = [];
    QuerySnapshot snapshot =
        await ins.collection("recipes").where('uid', isEqualTo: uid).get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      recipes.add(RecipeModel.fromMap(snapshot.docs[i]));
    }
    return recipes;
  }

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
        breakfastFood: {},
        breakfastRecipes: {},
        lunchFood: {},
        lunchRecipes: {},
        dinnerFood: {},
        dinnerRecipes: {},
        snacksFood: {},
        snacksRecipes: {},
      exercises: {}
    );
    await ins
        .collection("users")
        .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
        .collection('dairy')
        .doc('${date.day}-${date.month}-${date.year}')
        .set(map.toMap());
    return map;
  }

  Future<bool> dateIsAdd(DateTime date) async {
    DocumentSnapshot doc = await ins
        .collection("users")
        .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
        .collection('dairy')
        .doc('${date.day}-${date.month}-${date.year}')
        .get();
    return doc.exists;
  }

  void addDayFoodOrRecipe(DateTime date, String meal,
      {FoodInfoModel? food, RecipeInfoModel? recipe}) async {
    if (!(await dateIsAdd(date))) {
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
    await ins
        .collection("users")
        .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
        .collection('dairy')
        .doc('${date.day}-${date.month}-${date.year}')
        .update({'isFree': isFree});
  }

  Future<DayModel> getDay(DateTime date) async {
    if (!(await dateIsAdd(date))) {
      DayModel day = await addDay(date);
      return day;
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
