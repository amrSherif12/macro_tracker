import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';
import 'package:macro_tracker_2/data/models/quick_calorie_model.dart';
import 'package:macro_tracker_2/data/models/recipe_model.dart';

abstract class ConsumableModel {
  String? id;
  String name;
  int kcal;
  double protein;
  double carb;
  double fat;

  ConsumableModel(
      {this.id,
      required this.name,
      required this.kcal,
      required this.protein,
      required this.carb,
      required this.fat});

  Map<String, dynamic> toMap();

  factory ConsumableModel.fromMap(DocumentSnapshot map) =>
      throw UnimplementedError(
          'fromMap() must be implemented in concrete classes');

  static List<ConsumableModel> fromListMap(List map) {
    List<ConsumableModel> list = [];
    for (int i = 0; i < map.length; i++) {
      if (map[i]['ingredients'] != null) {
        list.add(RecipeModel.fromMap(map[i]));
      } else if (map[i]['amount'] != null || map[i]['uid'] != null) {
        list.add(FoodModel.fromMap(map[i]));
      } else {
        list.add(QuickCalorieModel.fromMap(map[i]));
      }
    }
    return list;
  }
}
