import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';

class RecipeModel {
  String? id;
  String uid;
  String recipe;
  int kcal;

  RecipeModel(
      {this.id, required this.uid, required this.recipe, required this.kcal});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'recipe': recipe,
      'kcal': kcal,
    };
  }

  static RecipeModel fromMap(DocumentSnapshot map) {
    return RecipeModel(
      uid: map["uid"],
      id: map.id,
      recipe: map["recipe"],
      kcal: map["kcal"],
    );
  }
}

class RecipeInfoModel extends RecipeModel {
  List ingredients;
  List amounts;
  double protein;
  double carb;
  double fat;

  RecipeInfoModel({
    super.id,
    required super.uid,
    required super.recipe,
    required super.kcal,
    required this.ingredients,
    required this.amounts,
    required this.protein,
    required this.carb,
    required this.fat,
  });

  Map<String, dynamic> toMap_() {
    List ingredientsMap = [];
    for (int i = 0; i < ingredients.length; i++) {
      FoodInfoModel food = ingredients[i];
      ingredientsMap.add(food.toMap());
    }
    return {
      'uid': uid,
      'recipe': recipe,
      'ingredients': ingredientsMap,
      'amounts': amounts,
      'kcal': kcal,
      'protein': protein,
      'carb': carb,
      'fat': fat,
    };
  }

  static RecipeInfoModel fromMap(DocumentSnapshot map) {
    List<FoodModel> food = [];
    for (int i = 0; i < map['ingredients'].length; i++) {
      final ingredient = map['ingredients'][i];
      food.add(FoodModel(
        id: ingredient['id'],
        food: ingredient['food'],
        kcal: ingredient['kcal'],
        unit: ingredient['unit'],
        uid: ingredient['uid'],
      ));
    }
    return RecipeInfoModel(
      id: map.id,
      uid: map["uid"],
      recipe: map["recipe"],
      ingredients: food,
      amounts: map["amounts"],
      kcal: map["kcal"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
    );
  }
}
