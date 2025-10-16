import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/presentation/widgets/toast.dart';
import 'package:testt/data/helpers/random.dart';

import '../auth_helper.dart';

class FoodRepository {
  FoodRepository._privateConstructor();

  static final FoodRepository _instance = FoodRepository._privateConstructor();

  static FoodRepository get instance => _instance;
  final ins = FirebaseFirestore.instance;

  Future<FoodModel> addFood(FoodModel food) async {
    DocumentReference reference = await ins
        .collection("food")
        .add(food.toMap());
    await saveFood(reference.id);
    return FoodModel.fromDocument(await reference.get());
  }

  Future<void> saveFood(
    String id, {
    bool isRecipe = false,
    bool unSave = false,
  }) async {
    final uid = AuthenticationHelper.instance.auth.currentUser!.uid;
    DocumentSnapshot document = await ins.collection("users").doc(uid).get();
    try {
      document.get(isRecipe ? 'recipes' : 'foods');
    } catch (e) {
      if (await connectedToInternet()) {
        await ins.collection("users").doc(uid).update({
          isRecipe ? 'recipes' : 'foods': [],
        });
      }
    }
    await ins.collection("users").doc(uid).update({
      isRecipe ? 'recipes' : 'foods': unSave
          ? FieldValue.arrayRemove([id])
          : FieldValue.arrayUnion([id]),
    });
  }

  Future<void> updateFood(FoodModel food) async {
    await ins.collection("food").doc(food.id!).set(food.toMap());
  }

  Future<FoodModel> getFood(String id) async {
    FoodModel food = FoodModel.fromDocument(
      await ins.collection("food").doc(id).get(),
    );
    return food;
  }

  Future<RecipeModel> addRecipe(
    String name,
    String description,
    List<Map> ingredients,
    List<TextEditingController> amounts, {
    String? id,
  }) async {
    RecipeModel recipe = RecipeModel(
      uid: AuthenticationHelper.instance.auth.currentUser!.uid,
      name: name,
      lowerName: name.toLowerCase(),
      description: description,
      ingredients: ingredients,
    );
    if (id == null) {
      DocumentReference reference = await ins
          .collection("recipes")
          .add(recipe.toMap());
      await saveFood(reference.id, isRecipe: true);
      return RecipeModel.fromDocument(await reference.get());
    } else {
      await ins.collection("recipes").doc(id).update(recipe.toMap());
      recipe.id = id;
      return recipe;
    }
  }

  Future<void> updateRecipeAmounts(
    RecipeModel recipe,
    List<TextEditingController> amounts,
  ) async {
    for (int i = 0; i < amounts.length; i++) {
      recipe.ingredients[i]['amount'] = double.parse(amounts[i].text);
    }
    await ins.collection("recipes").doc(recipe.id!).set(recipe.toMap());
  }

  Future<RecipeModel> getRecipe(String id) async {
    RecipeModel recipe = RecipeModel.fromDocument(
      await ins.collection("recipes").doc(id).get(),
    );
    return recipe;
  }

  Future<void> deleteFood(String id, {bool isRecipe = false}) async {
    await ins
        .collection('users')
        .doc(AuthenticationHelper.instance.auth.currentUser!.uid)
        .update({
          isRecipe ? 'recipes' : 'foods': FieldValue.arrayRemove([id]),
        });
  }

  Future<List<RecipeModel>> getRecipes(List sub) async {
    List<RecipeModel> recipes = [];
    QuerySnapshot foodSnapshot = await ins
        .collection("recipes")
        .where(FieldPath.documentId, whereIn: sub)
        .get();
    for (int i = 0; i < foodSnapshot.docs.length; i++) {
      recipes.add(RecipeModel.fromDocument(foodSnapshot.docs[i]));
    }
    return recipes;
  }

  Future<List<FoodModel>> getFoods(List sub) async {
    List<FoodModel> foods = [];
    QuerySnapshot foodSnapshot = await ins
        .collection("food")
        .where(FieldPath.documentId, whereIn: sub)
        .get();
    for (int i = 0; i < foodSnapshot.docs.length; i++) {
      foods.add(FoodModel.fromDocument(foodSnapshot.docs[i]));
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
