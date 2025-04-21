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

  factory ConsumableModel.formDocument(DocumentSnapshot map) =>
      throw UnimplementedError(
          'fromDocument() must be implemented in concrete classes');

  static List<ConsumableModel> fromListMap(Map map) {
    List<ConsumableModel> list = [];
    final keys = map.keys.toList();
    for (int i = 0; i < map.length; i++) {
      if (map[keys[i]]['ingredients'] != null) {
        list.add(RecipeModel.fromMap(map[keys[i]], keys[i]));
      } else if (map[keys[i]]['amount'] != null || map[keys[i]]['uid'] != null) {
        list.add(FoodModel.fromMap(map[keys[i]], keys[i]));
      } else {
        list.add(QuickCalorieModel.fromMap(map[keys[i]], keys[i]));
      }
    }
    return list;
  }
}
