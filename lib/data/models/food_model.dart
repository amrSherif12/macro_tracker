import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  String uid;
  String? id;
  String food;
  int kcal;
  String unit;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'food': food,
      'kcal': kcal,
      'unit': unit,
    };
  }

  static FoodModel fromMap(DocumentSnapshot map) {
    return FoodModel(
      id: map.id,
      uid: map["uid"],
      food: map["food"],
      kcal: map["kcal"],
      unit: map["unit"],
    );
  }

  FoodModel(
      {this.id,
      required this.uid,
      required this.food,
      required this.kcal,
      required this.unit});
}

class FoodInfoModel extends FoodModel {
  FoodInfoModel(
      {super.id,
      required super.food,
      required super.kcal,
      required super.unit,
      required super.uid,
      required this.protein,
      required this.carb,
      required this.fat});

  double protein;
  double carb;
  double fat;

  Map<String, dynamic> toMap_() {
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

  static FoodInfoModel fromMap(DocumentSnapshot map) {
    return FoodInfoModel(
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
}
