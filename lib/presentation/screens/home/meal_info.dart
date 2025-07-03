import 'package:flutter/material.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/data/models/consumable_model.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/presentation/widgets/food_tile.dart';
import 'package:testt/presentation/widgets/recipe_tile.dart';
import 'package:testt/random.dart';

import '../../../constants/colors.dart';

class MealInfo extends StatefulWidget {
  final List<ConsumableModel> food;
  final String meal;
  final DateTime date;
  const MealInfo({
    super.key,
    required this.meal,
    required this.food,
    required this.date,
  });

  @override
  State<MealInfo> createState() => _MealInfoState();
}

class _MealInfoState extends State<MealInfo> {
  int kcal = 0;
  double protein = 0;
  double carb = 0;
  double fat = 0;

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.food.length; i++) {
      Map macros = widget.food[i].getMacros();
      kcal = macros['kcal'];
      protein = macros['protein'];
      carb = macros['carb'];
      fat = macros['fat'];
    }

    Widget macroBuilder(String macro, double val) {
      return Column(
        children: [
          Text(
            macro != "KCAL"
                ? "${val.withoutZeroDecimal()} g"
                : val.withoutZeroDecimal(),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'F',
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            macro,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'F',
              fontSize: 17,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: ConstColors.main,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: ConstColors.sec,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.meal,
          style: TextStyle(color: Colors.white, fontFamily: 'f'),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                macroBuilder("KCAL", kcal.toDouble()),
                macroBuilder("PROTEIN", protein),
                macroBuilder("CARB", carb),
                macroBuilder("FAT", fat),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Column(
            children: [
              if (index == 0) const SizedBox(height: 20),
              widget.food[index] is RecipeModel
                  ? RecipeTile(
                      recipe: widget.food[index] as RecipeModel,
                      date: widget.date,
                      tile: Tile.removeDairy,
                      meal: widget.meal,
                    )
                  : FoodTile(
                      food: widget.food[index] as FoodModel,
                      date: widget.date,
                      tile: Tile.removeDairy,
                      meal: widget.meal,
                    ),
            ],
          );
        },
        itemCount: widget.food.length,
      ),
    );
  }
}
