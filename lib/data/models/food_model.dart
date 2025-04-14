import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  String uid;
  String? id;
  String food;
  int kcal;
  String unit;
  double protein;
  double carb;
  double fat;
  double? amount;

  FoodModel(
      {this.id,
      required this.food,
      required this.kcal,
      required this.unit,
      required this.uid,
      required this.protein,
      required this.carb,
      this.amount,
      required this.fat});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'food': food,
      'kcal': kcal,
      'unit': unit,
      'protein': protein,
      'carb': carb,
      'fat': fat,
    };
  }

  static FoodModel fromMap(DocumentSnapshot map) {
    return FoodModel(
      id: map.id,
      uid: map["uid"],
      food: map["food"],
      kcal: map["kcal"],
      unit: map["unit"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
    );
  }

  static List<FoodModel> fromListMap(Map map) {
    List<FoodModel> list = [];
    for (int i = 0; i < map.length; i++) {
      list.add(fromMap(map[map.keys.toList()[i]]));
    }
    return list;
  }
}
