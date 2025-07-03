import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testt/data/models/consumable_model.dart';

class QuickCalorieModel extends ConsumableModel {
  QuickCalorieModel({
    super.id,
    required super.name,
    required super.description,
    required super.lowerName,
    required super.kcal,
    required super.protein,
    required super.carb,
    required super.fat,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'kcal': kcal,
      'protein': protein,
      'carb': carb,
      'fat': fat,
      'description': description,
    };
  }

  @override
  factory QuickCalorieModel.fromDocument(DocumentSnapshot map) {
    return QuickCalorieModel(
      id: map.id,
      name: map["name"],
      kcal: map["kcal"],
      protein: map["protein"],
      carb: map["carb"],
      lowerName: map["lowerName"],
      fat: map["fat"],
      description: map["description"],
    );
  }

  @override
  factory QuickCalorieModel.fromMap(Map map, String id) {
    return QuickCalorieModel(
      id: id,
      name: map["name"],
      kcal: map["kcal"],
      protein: map["protein"],
      carb: map["carb"],
      fat: map["fat"],
      lowerName: map["lowerName"],
      description: map["description"],
    );
  }

  @override
  Map<String, dynamic> getMacros() {
    return {'kcal': kcal, 'protein': protein, 'carb': carb, 'fat': fat};
  }
}
