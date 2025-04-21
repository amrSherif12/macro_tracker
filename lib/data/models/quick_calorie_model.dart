import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_tracker_2/data/models/consumable_model.dart';

class QuickCalorieModel extends ConsumableModel {
  QuickCalorieModel(
      {super.id,
      required super.name,
      required super.kcal,
      required super.protein,
      required super.carb,
      required super.fat});

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'kcal': kcal,
      'protein': protein,
      'carb': carb,
      'fat': fat,
    };
  }

  factory QuickCalorieModel.formDocument(DocumentSnapshot map) {
    return QuickCalorieModel(
      id: map.id,
      name: map["name"],
      kcal: map["kcal"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
    );
  }

  factory QuickCalorieModel.fromMap(Map map, String id) {
    return QuickCalorieModel(
      id: id,
      name: map["name"],
      kcal: map["kcal"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
    );
  }
}
