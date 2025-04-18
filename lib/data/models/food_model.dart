import 'package:cloud_firestore/cloud_firestore.dart';

import 'quick_calorie_model.dart';

class FoodModel extends QuickCalorieModel {
  double? amount;
  String unit;
  String? uid;

  FoodModel(
      {this.amount,
      required this.unit,
      super.id,
      required super.name,
      required super.kcal,
      this.uid,
      required super.protein,
      required super.carb,
      required super.fat});

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'kcal': kcal,
      'protein': protein,
      'carb': carb,
      'fat': fat,
      'unit': unit
    };
    if (uid != null) map.addAll({'uid': uid});
    if (amount != null) map.addAll({'amount': amount});
    return map;
  }

  static FoodModel fromMap(DocumentSnapshot map) {
    FoodModel food = FoodModel(
      id: map.id,
      name: map["name"],
      kcal: map["kcal"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
      unit: map["unit"],
    );
    try {
      if (map['uid'] != null) food.uid = map['uid'];
    } catch (e) {}
    try {
      if (map['amount'] != null) food.amount = map['amount'];
    } catch (e) {}

    return food;
  }
}
