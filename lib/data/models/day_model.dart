import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_tracker_2/data/models/consumable_model.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';
import 'package:macro_tracker_2/data/models/recipe_model.dart';

class DayModel {
  DateTime date;
  int kcalConsumed;
  int kcalGoal;
  int kcalBurned;
  double proteinCons;
  double proteinGoal;
  double carbCons;
  double carbGoal;
  double fatCons;
  double fatGoal;
  bool isFree;
  List<ConsumableModel> breakfast;
  List<ConsumableModel> lunch;
  List<ConsumableModel> dinner;
  List<ConsumableModel> snacks;
  List exercises;

  DayModel({
    required this.date,
    required this.kcalConsumed,
    required this.kcalGoal,
    required this.kcalBurned,
    required this.proteinCons,
    required this.proteinGoal,
    required this.carbCons,
    required this.carbGoal,
    required this.fatCons,
    required this.fatGoal,
    required this.isFree,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'kcalGoal': kcalGoal,
      'kcalConsumed': kcalConsumed,
      'kcalBurned': kcalBurned,
      'proteinCons': proteinCons,
      'proteinGoal': proteinGoal,
      'carbCons': carbCons,
      'carbGoal': carbGoal,
      'fatCons': fatCons,
      'fatGoal': fatGoal,
      'isFree': isFree,
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'snacks': snacks,
      'exercises': exercises,
    };
  }

  static DayModel fromMap(DocumentSnapshot map) {
    return DayModel(
      date: map["date"].toDate(),
      kcalConsumed: map["kcalConsumed"],
      kcalGoal: map["kcalGoal"],
      kcalBurned: map["kcalBurned"],
      proteinCons: map["proteinCons"],
      proteinGoal: map["proteinGoal"],
      carbCons: map["carbCons"],
      carbGoal: map["carbGoal"],
      fatCons: map["fatCons"],
      fatGoal: map["fatGoal"],
      isFree: map["isFree"],
      breakfast: ConsumableModel.fromListMap(map["breakfast"]),
      lunch: ConsumableModel.fromListMap(map["lunch"]),
      dinner: ConsumableModel.fromListMap(map["dinner"]),
      snacks: ConsumableModel.fromListMap(map["snacks"]),
      exercises: [],
    );
  }
}
