import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/presentation/widgets/toast.dart';
import 'package:testt/random.dart';

import '../auth_helper.dart';

class FoodRepository {
  FoodRepository._privateConstructor();

  static final FoodRepository _instance = FoodRepository._privateConstructor();

  static FoodRepository get instance => _instance;
  final ins = FirebaseFirestore.instance;

  Future<void> addFood(BuildContext context, FoodModel food) async {
    DocumentReference reference = await ins
        .collection("food")
        .add(food.toMap());
    await saveFood(reference.id);
    toastBuilder('Food created', context);
  }

  Future<void> saveFood(String id, {bool isRecipe = false, bool unSave = false}) async {
    final uid = AuthenticationHelper.instance.auth.currentUser!.uid;
    DocumentSnapshot document = await ins.collection("users").doc(uid).get();
    try {
      document.get(isRecipe ? 'recipes' : 'foods');
    } catch (e) {
      if (await connectedToInternet()) {
        await ins.collection("users").doc(uid).update(
          {isRecipe ? 'recipes' : 'foods': []});
      }
    }
    await ins.collection("users").doc(uid).update({
      isRecipe ? 'recipes' : 'foods': unSave ? FieldValue.arrayRemove([id]) : FieldValue.arrayUnion([id]),
    });
  }

  Future<void> updateFood(BuildContext context, FoodModel food) async {
    await ins.collection("food").doc(food.id!).set(food.toMap());
    toastBuilder('Food updated', context);
  }

  Future<FoodModel> getFood(String id) async {
    FoodModel food = FoodModel.fromDocument(
      await ins.collection("food").doc(id).get(),
    );
    return food;
  }

  Future<void> addRecipe(
    BuildContext context,
    String name,
    String description,
    List<FoodModel> foods,
    List<TextEditingController> amounts,
  ) async {
    List<Map> ingredients = [];
    for (int i = 0; i < foods.length; i++) {
      ingredients.add({
        'name': foods[i].name,
        'kcal': foods[i].kcal,
        'protein': foods[i].protein,
        'carb': foods[i].carb,
        'fat': foods[i].fat,
        'unit': foods[i].unit,
        'amount': double.parse(amounts[i].text),
      });
    }
    RecipeModel recipe = RecipeModel(
      uid: AuthenticationHelper.instance.auth.currentUser!.uid,
      name: name,
      lowerName: name.toLowerCase(),
      description: description,
      ingredients: ingredients,
    );
    DocumentReference reference = await ins
        .collection("recipes")
        .add(recipe.toMap());
    await saveFood(reference.id, isRecipe: true);
    toastBuilder('Recipe created', context);
  }

  Future<void> updateRecipeAmounts(BuildContext context, RecipeModel recipe, List<TextEditingController> amounts) async {

    for (int i = 0; i < amounts.length; i++) {
      recipe.ingredients[i]['amount'] = double.parse(amounts[i].text);
    }
    await ins.collection("recipes").doc(recipe.id!).set(recipe.toMap());
    toastBuilder('Recipes updated', context);
  }

  Future<RecipeModel> getRecipe(String id) async {
    RecipeModel recipe = RecipeModel.fromDocument(
      await ins.collection("recipes").doc(id).get(),
    );
    return recipe;
  }

  Future<void> deleteFood(
    BuildContext context,
    String id, {
    bool isRecipe = false,
  }) async {
    await ins
        .collection('users')
        .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
        .update({
          isRecipe ? 'recipes' : 'foods': FieldValue.arrayRemove([id]),
        });
    toastBuilder(isRecipe ? 'Recipe deleted' : 'Food deleted', context);
  }

  Future<List<RecipeModel>> getRecipes() async {
    List<String> recipesIds = await getSaved(true);
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

  Future<List<FoodModel>> getFoods() async {
    List<FoodModel> foods = [];
    List<String> foodsIds = await getSaved(false);
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

  Future<List<String>> getSaved(bool isRecipe) async {
    final uid = AuthenticationHelper.instance.auth.currentUser!.uid;
    DocumentSnapshot userSnapshot = await ins
        .collection("users")
        .doc(uid)
        .get();
    try {
      return userSnapshot[isRecipe ? 'recipes' : 'foods'].cast<String>();
    } catch (e) {
      return [];
    }
  }
}
