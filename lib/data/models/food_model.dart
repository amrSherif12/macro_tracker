import 'package:cloud_firestore/cloud_firestore.dart';

import 'quick_calorie_model.dart';

class FoodModel extends QuickCalorieModel {
  double? amount;
  String unit;
  String? uid;

  FoodModel({
    this.amount,
    required this.unit,
    required super.description,
    super.id,
    required super.name,
    required super.kcal,
    this.uid,
    required super.protein,
    required super.carb,
    required super.lowerName,
    required super.fat,
  });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'kcal': kcal,
      'protein': protein,
      'carb': carb,
      'fat': fat,
      'unit': unit,
      'description': description,
      'lowerName': lowerName,
    };
    if (uid != null) map.addAll({'uid': uid});
    if (amount != null) map.addAll({'amount': amount});
    if (id != null) map.addAll({'id': id});
    return map;
  }

  @override
  factory FoodModel.fromDocument(DocumentSnapshot map) {
    FoodModel food = FoodModel(
      id: map.id,
      name: map["name"],
      kcal: map["kcal"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
      unit: map["unit"],
      description: map["description"],
      lowerName: map["lowerName"],
    );
    try {
      if (map['uid'] != null) food.uid = map['uid'];
    } catch (e) {}
    try {
      if (map['amount'] != null) food.amount = map['amount'];
    } catch (e) {}

    return food;
  }

  @override
  factory FoodModel.fromMap(Map map, String id) {
    FoodModel food = FoodModel(
      id: id,
      name: map["name"],
      kcal: map["kcal"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
      unit: map["unit"],
      lowerName: map["lowerName"],
      description: map["description"],
    );
    if (map['uid'] != null) food.uid = map['uid'];
    if (map['amount'] != null) food.amount = map['amount'];

    return food;
  }

  @override
  Map<String, dynamic> getMacros() {
    int kcal = (this.kcal * amount!).toInt();
    double protein = this.protein * amount!;
    double carb = this.carb * amount!;
    double fat = this.fat * amount!;
    if (unit == 'per 100 gm' || unit == 'per 100 ml') {
      kcal = (kcal / 100).toInt();
      protein = protein / 100;
      carb = carb / 100;
      fat = fat / 100;
    }
    return {'kcal': kcal, 'protein': protein, 'carb': carb, 'fat': fat};
  }
}
