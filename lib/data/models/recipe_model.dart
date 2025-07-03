import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testt/data/models/consumable_model.dart';
import 'package:testt/data/models/food_model.dart';

class RecipeModel extends ConsumableModel {
  String uid;
  Map ingredients;
  List amounts;
  int? servings;

  RecipeModel({
    super.id,
    required this.uid,
    required super.description,
    required super.name,
    required super.kcal,
    required this.ingredients,
    required this.amounts,
    required super.protein,
    required super.carb,
    required super.fat,
    required super.lowerName,
    this.servings,
  });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'ingredients': ingredients,
      'amounts': amounts,
      'kcal': kcal,
      'description': description,
      'protein': protein,
      'carb': carb,
      'fat': fat,
      'uid': uid,
      'lowerName': lowerName,
    };
    if (servings != null) map.addAll({'servings': servings});
    return map;
  }

  @override
  factory RecipeModel.fromMap(Map map, String id) {
    RecipeModel recipe = RecipeModel(
      id: id,
      uid: map["uid"],
      name: map["name"],
      ingredients: map['ingredients'],
      description: map['description'],
      amounts: map["amounts"],
      kcal: map["kcal"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
      lowerName: map["lowerName"],
    );

    if (map['servings'] != null) recipe.servings = map['servings'];

    return recipe;
  }

  @override
  factory RecipeModel.fromDocument(DocumentSnapshot map) {
    RecipeModel recipe = RecipeModel(
      id: map.id,
      uid: map["uid"],
      name: map["name"],
      ingredients: map['ingredients'],
      amounts: map["amounts"],
      kcal: map["kcal"],
      description: map["description"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
      lowerName: map["lowerName"],
    );

    try {
      if (map['servings'] != null) recipe.servings = map['servings'];
    } catch (e) {}

    return recipe;
  }

  @override
  Map<String, dynamic> getMacros() {
    return {
      'kcal': kcal * (servings ?? 1),
      'protein': protein * (servings ?? 1),
      'carb': carb * (servings ?? 1),
      'fat': fat * (servings ?? 1),
    };
  }
}
