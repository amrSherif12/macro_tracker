import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';
import 'package:macro_tracker_2/data/models/recipe_model.dart';
import 'package:macro_tracker_2/presentation/widgets/toast.dart';

import '../auth_helper.dart';

class FoodRepository {
  FoodRepository._privateConstructor();

  static final FoodRepository _instance = FoodRepository._privateConstructor();

  static FoodRepository get instance => _instance;
  final ins = FirebaseFirestore.instance;

  void addFood(BuildContext context, FoodModel food) async {
    DocumentReference reference =
        await ins.collection("food").add(food.toMap());
    saveFood(reference.id);
    toastBuilder('Food created', context);
  }

  Future<void> saveFood(String id, {bool isRecipe = false}) async {
    final uid = AuthenticationHelper.instance.auth.currentUser!.uid;
    await ins.collection("users").doc(uid).update({
      isRecipe ? 'recipes' : 'foods': FieldValue.arrayUnion([id])
    });
  }

  Future<void> updateFood(BuildContext context, FoodModel food) async {
    await ins.collection("food").doc(food.id!).set(food.toMap());
    toastBuilder('Food updated', context);
  }

  Future<FoodModel> getFood(String id) async {
    FoodModel food =
        FoodModel.fromDocument(await ins.collection("food").doc(id).get());
    return food;
  }

  Future<List<FoodModel>> getFoods() async {
    final uid = AuthenticationHelper.instance.auth.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await ins.collection("users").doc(uid).get();
    List foodsIds = [];
    try {
      foodsIds = userSnapshot['foods'];
    } catch (e) {
      return [];
    }
    List<FoodModel> foods = [];

    for (int i = 0; i < ((foodsIds.length.toDouble()) / 30).ceil(); i++) {
      List sub = [];
      if (i < ((foodsIds.length.toDouble()) / 30).ceil() - 1) {
        sub = foodsIds.sublist(0 + (i * 30), 30 + (i * 30));
      } else {
        sub = foodsIds.sublist(0 + (i * 30), foodsIds.length);
      }
      QuerySnapshot foodSnapshot = await ins
          .collection("food")
          .where(FieldPath.documentId, whereIn: sub)
          .get();
      for (int i = 0; i < foodSnapshot.docs.length; i++) {
        foods.add(FoodModel.fromDocument(foodSnapshot.docs[i]));
      }
    }
    return foods;
  }

  Future<void> addRecipe(BuildContext context, String name,
      List<FoodModel> foods, List<TextEditingController> amounts) async {
    List<double> amountsDouble = [];
    int kcal = 0;
    double protein = 0;
    double carb = 0;
    double fat = 0;

    for (int i = 0; i < foods.length; i++) {
      amountsDouble.add(double.parse(amounts[i].text));
    }
    for (int i = 0; i < foods.length; i++) {
      if (foods[i].unit == 'per piece' || foods[i].unit == 'per table spoon') {
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

    Map ingredients = {for (var food in foods) food.name: food.unit};

    RecipeModel recipe = RecipeModel(
        uid: AuthenticationHelper.instance.auth.currentUser!.uid,
        name: name,
        kcal: kcal,
        ingredients: ingredients,
        amounts: amountsDouble,
        protein: protein,
        carb: carb,
        fat: fat);
    DocumentReference reference =
        await ins.collection("recipes").add(recipe.toMap());
    saveFood(reference.id, isRecipe: true);
    toastBuilder('Recipe created', context);
  }

  Future<void> updateRecipe(BuildContext context, RecipeModel recipe) async {
    await ins.collection("recipes").doc(recipe.id!).set(recipe.toMap());
    toastBuilder('Recipes updated', context);
  }

  Future<RecipeModel> getRecipe(String id) async {
    RecipeModel recipe =
        RecipeModel.fromDocument(await ins.collection("recipes").doc(id).get());
    return recipe;
  }

  Future<void> deleteFood(BuildContext context, String id,
      {bool isRecipe = false}) async {
    await ins
        .collection('users')
        .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
        .update({
      isRecipe ? 'recipes' : 'foods': FieldValue.arrayRemove([id])
    });
    toastBuilder(isRecipe ? 'Recipe deleted' : 'Food deleted', context);
  }

  Future<List<RecipeModel>> getRecipes() async {
    final uid = AuthenticationHelper.instance.auth.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await ins.collection("users").doc(uid).get();
    List recipesIds = [];
    try {
      recipesIds = userSnapshot['recipes'];
    } catch (e) {
      return [];
    }
    List<RecipeModel> recipes = [];
    for (int i = 0; i < ((recipesIds.length.toDouble()) / 30).ceil(); i++) {
      List sub = [];
      if (i < ((recipesIds.length.toDouble()) / 30).ceil() - 1) {
        sub = recipesIds.sublist(0 + (i * 30), 30 + (i * 30));
      } else {
        sub = recipesIds.sublist(0 + (i * 30), recipesIds.length);
      }
      QuerySnapshot foodSnapshot = await ins
          .collection("recipes")
          .where(FieldPath.documentId, whereIn: sub)
          .get();
      for (int i = 0; i < foodSnapshot.docs.length; i++) {
        recipes.add(RecipeModel.fromDocument(foodSnapshot.docs[i]));
      }
    }

    return recipes;
  }
}
