import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_tracker_2/data/models/consumable_model.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';

class RecipeModel extends ConsumableModel {
  String uid;
  Map ingredients;
  List amounts;

  RecipeModel({
    super.id,
    required this.uid,
    required super.name,
    required super.kcal,
    required this.ingredients,
    required this.amounts,
    required super.protein,
    required super.carb,
    required super.fat,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'ingredients': ingredients,
      'amounts': amounts,
      'kcal': kcal,
      'protein': protein,
      'carb': carb,
      'fat': fat,
    };
  }

  static RecipeModel fromMap(DocumentSnapshot map) {
    return RecipeModel(
      id: map.id,
      uid: map["uid"],
      name: map["name"],
      ingredients: map['ingredients'],
      amounts: map["amounts"],
      kcal: map["kcal"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
    );
  }
}
