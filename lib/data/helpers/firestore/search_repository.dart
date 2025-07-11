import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testt/data/models/consumable_model.dart';
import 'package:testt/data/models/filter_model.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/data/models/recipe_model.dart';

class SearchRepository {
  SearchRepository._privateConstructor();

  static final SearchRepository _instance =
      SearchRepository._privateConstructor();

  static SearchRepository get instance => _instance;
  final ins = FirebaseFirestore.instance;

  Future<List<ConsumableModel>> searchFood(
    String queryString,
    FilterModel filters,
  ) async {
    Query query = ins
        .collection(filters.isRecipe ? 'recipes' : 'food')
        .where('lowerName', isGreaterThanOrEqualTo: queryString)
        .where('lowerName', isLessThan: '${queryString}z');
    if (filters.filtersOn) {
      query = query
          .where(
            'kcal',
            isLessThanOrEqualTo: filters.kcalEnd,
            isGreaterThanOrEqualTo: filters.kcalStart,
          )
          .where(
            'protein',
            isLessThanOrEqualTo: filters.proteinEnd,
            isGreaterThanOrEqualTo: filters.proteinStart,
          )
          .where(
            'carb',
            isLessThanOrEqualTo: filters.carbEnd,
            isGreaterThanOrEqualTo: filters.carbStart,
          )
          .where(
            'fat',
            isLessThanOrEqualTo: filters.fatEnd,
            isGreaterThanOrEqualTo: filters.fatStart,
          );
    }
    QuerySnapshot snapshot = await query.limit(20).get();
    List<ConsumableModel> consumables = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (!filters.isRecipe) {
        consumables.add(FoodModel.fromDocument(snapshot.docs[i]));
      } else {
        consumables.add(RecipeModel.fromDocument(snapshot.docs[i]));
      }
    }
    return consumables;
  }
}
