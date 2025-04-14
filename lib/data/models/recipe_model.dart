import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';

class RecipeModel {
  String? id;
  String uid;
  String recipe;
  int kcal;
  List ingredients;
  List amounts;
  double protein;
  double carb;
  double fat;

  RecipeModel({
    this.id,
    required this.uid,
    required this.recipe,
    required this.kcal,
    required this.ingredients,
    required this.amounts,
    required this.protein,
    required this.carb,
    required this.fat,
  });

  Map<String, dynamic> toMap() {
    List ingredientsMap = [];
    for (int i = 0; i < ingredients.length; i++) {
      FoodModel food = ingredients[i];
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

  static RecipeModel fromMap(DocumentSnapshot map) {
    List<FoodModel> food = [];
    for (int i = 0; i < map['ingredients'].length; i++) {
      final ingredient = map['ingredients'][i];
      food.add(FoodModel(
        id: ingredient['id'],
        food: ingredient['food'],
        kcal: ingredient['kcal'],
        unit: ingredient['unit'],
        uid: ingredient['uid'],
        carb: ingredient['carb'],
        fat: ingredient['fat'],
        protein: ingredient['protein'],
      ));
    }
    return RecipeModel(
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

  static List<RecipeModel> fromListMap(Map map) {
    List<RecipeModel> list = [];
    for (int i = 0; i < map.length; i++) {
      list.add(fromMap(map[map.keys.toList()[i]]));
    }
    return list;
  }
}
