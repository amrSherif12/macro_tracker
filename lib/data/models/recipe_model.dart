import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testt/data/models/consumable_model.dart';
import 'package:testt/data/models/food_model.dart';

class RecipeModel extends ConsumableModel {
  String uid;
  List ingredients;
  int? servings;

  RecipeModel({
    super.id,
    required this.uid,
    required super.description,
    required super.name,
    super.kcal = 0,
    required this.ingredients,
    super.protein = 0,
    super.carb = 0,
    super.fat = 0,
    required super.lowerName,
    this.servings,
  });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'ingredients': ingredients,
      'description': description,
      'uid': uid,
      'lowerName': lowerName,
    };
    if (servings != null) map.addAll({'servings': servings});
    return map;
  }

  @override
  factory RecipeModel.fromMap(Map map, String id) {
    int totKcal = 0;
    double totProtein = 0;
    double totCarb = 0;
    double totFat = 0;
    for (int i = 0; i < map['ingredients'].length; i++) {
      double amount = map['ingredients'][i]['amount'];
      int kcal = ((map['ingredients'][i]['kcal'] as int) * amount).toInt();
      double protein = (map['ingredients'][i]['protein'] as double) * amount;
      double carb = (map['ingredients'][i]['carb'] as double) * amount;
      double fat = (map['ingredients'][i]['fat'] as double) * amount;
      if (map['ingredients'][i]['unit'] == 'per 100 gm' ||
          map['ingredients'][i]['unit'] == 'per 100 ml') {
        kcal = (kcal / 100).toInt();
        protein /= 100;
        carb /= 100;
        fat /= 100;
      }
      totKcal += kcal;
      totProtein += protein;
      totCarb += carb;
      totFat += fat;
    }
    RecipeModel recipe = RecipeModel(
      id: id,
      uid: map["uid"],
      name: map["name"],
      ingredients: map['ingredients'],
      description: map['description'],
      kcal: totKcal,
      protein: totProtein,
      carb: totCarb,
      fat: totFat,
      lowerName: map["lowerName"],
    );

    if (map['servings'] != null) recipe.servings = map['servings'];

    return recipe;
  }

  @override
  factory RecipeModel.fromDocument(DocumentSnapshot map) {
    int totKcal = 0;
    double totProtein = 0;
    double totCarb = 0;
    double totFat = 0;
    for (int i = 0; i < map['ingredients'].length; i++) {
      double amount = map['ingredients'][i]['amount'];
      int kcal = ((map['ingredients'][i]['kcal'] as int) * amount).toInt();
      double protein = (map['ingredients'][i]['protein'] as double) * amount;
      double carb = (map['ingredients'][i]['carb'] as double) * amount;
      double fat = (map['ingredients'][i]['fat'] as double) * amount;
      if (map['ingredients'][i]['unit'] == 'per 100 gm' ||
          map['ingredients'][i]['unit'] == 'per 100 ml') {
        kcal = (kcal / 100).toInt();
        protein /= 100;
        carb /= 100;
        fat /= 100;
      }
      totKcal += kcal;
      totProtein += protein;
      totCarb += carb;
      totFat += fat;
    }
    RecipeModel recipe = RecipeModel(
      id: map.id,
      uid: map["uid"],
      name: map["name"],
      ingredients: map['ingredients'],
      kcal: totKcal,
      description: map["description"],
      protein: totProtein,
      carb: totCarb,
      fat: totFat,
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

  void recalculateMacros() {
    int totKcal = 0;
    double totProtein = 0;
    double totCarb = 0;
    double totFat = 0;
    for (int i = 0; i < ingredients.length; i++) {
      double amount = ingredients[i]['amount'];
      int kcal = ((ingredients[i]['kcal'] as int) * amount).toInt();
      double protein = (ingredients[i]['protein'] as double) * amount;
      double carb = (ingredients[i]['carb'] as double) * amount;
      double fat = (ingredients[i]['fat'] as double) * amount;
      if (ingredients[i]['unit'] == 'per 100 gm' ||
          ingredients[i]['unit'] == 'per 100 ml') {
        kcal = (kcal / 100).toInt();
        protein /= 100;
        carb /= 100;
        fat /= 100;
      }
      totKcal += kcal;
      totProtein += protein;
      totCarb += carb;
      totFat += fat;
    }

      kcal = totKcal;
      protein = totProtein;
      carb = totCarb;
      fat = totFat;
  }


}
