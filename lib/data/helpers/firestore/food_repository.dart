import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:macro_tracker_2/data/models/day_model.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';
import 'package:macro_tracker_2/data/models/recipe_model.dart';
import 'package:macro_tracker_2/presentation/screens/food/food.dart';
import 'package:macro_tracker_2/presentation/widgets/toast.dart';
import 'package:macro_tracker_2/utils.dart';

import '../auth_helper.dart';

class FoodRepository {
  FoodRepository._privateConstructor();

  static final FoodRepository _instance = FoodRepository._privateConstructor();

  static FoodRepository get instance => _instance;
  final ins = FirebaseFirestore.instance;

  void addFood(BuildContext context, FoodModel food) async {
    food.id = idGenerator();
    ins.collection("food").add(food.toMap());
    toastBuilder('Food created', context);
  }

  Future<void> updateFood(BuildContext context, FoodModel food) async {
    await ins.collection("food").doc(food.id!).set(food.toMap());
    toastBuilder('Food updated', context);
  }

  Future<FoodModel> getFood(String id) async {
    FoodModel food =
        FoodModel.fromMap(await ins.collection("food").doc(id).get());
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
    List<FoodModel> foods = [];
    List<double> amountsDouble = [];
    int kcal = 0;
    double protein = 0;
    double carb = 0;
    double fat = 0;

    for (int i = 0; i < ids.length; i++) {
      foods.add(await FoodRepository.instance.getFood(ids[i].id!));
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

    RecipeModel recipe = RecipeModel(
        uid: AuthenticationHelper.instance.auth.currentUser!.uid,
        recipe: name,
        kcal: kcal,
        ingredients: foods,
        amounts: amountsDouble,
        protein: protein,
        carb: carb,
        fat: fat);
    await ins.collection("recipes").add(recipe.toMap());
    toastBuilder('Recipe created', context);
  }

  Future<void> updateRecipe(BuildContext context, RecipeModel recipe) async {
    await ins.collection("recipes").doc(recipe.id!).set(recipe.toMap());
    toastBuilder('Recipes updated', context);
  }

  Future<RecipeModel> getRecipe(String id) async {
    RecipeModel recipe =
        RecipeModel.fromMap(await ins.collection("recipes").doc(id).get());
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
}
