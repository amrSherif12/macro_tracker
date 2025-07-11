import 'package:testt/data/models/food_model.dart';
import 'package:testt/data/models/quick_calorie_model.dart';
import 'package:testt/data/models/recipe_model.dart';

abstract class ConsumableModel {
  String? id;
  String name;
  String? lowerName;
  String description;
  int kcal;
  double protein;
  double carb;
  double fat;

  ConsumableModel({
    this.id,
    required this.name,
    required this.kcal,
    required this.protein,
    this.lowerName,
    required this.description,
    required this.carb,
    required this.fat,
  });

  Map<String, dynamic> toMap();

  Map<String, dynamic> getMacros();

  static List<ConsumableModel> fromListMap(Map map) {
    List<ConsumableModel> list = [];
    final keys = map.keys.toList();
    for (int i = 0; i < map.length; i++) {
      if (map[keys[i]]['ingredients'] != null) {
        list.add(RecipeModel.fromMap(map[keys[i]], keys[i]));
      } else if (map[keys[i]]['amount'] != null ||
          map[keys[i]]['uid'] != null) {
        list.add(FoodModel.fromMap(map[keys[i]], keys[i]));
      } else {
        list.add(QuickCalorieModel.fromMap(map[keys[i]], keys[i]));
      }
    }
    return list;
  }
}
