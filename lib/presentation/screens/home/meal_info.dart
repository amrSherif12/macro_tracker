import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/data/helpers/random.dart';
import 'package:testt/data/models/consumable_model.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/logic/home/home_cubit.dart';
import 'package:testt/presentation/widgets/food_tile.dart';
import 'package:testt/presentation/widgets/recipe_tile.dart';

import '../../../constants/colors.dart';

class MealInfo extends StatefulWidget {
  final String meal;
  final DateTime date;

  const MealInfo({super.key, required this.meal, required this.date});

  @override
  State<MealInfo> createState() => _MealInfoState();
}

class _MealInfoState extends State<MealInfo> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        int kcal = 0;
        double protein = 0;
        double carb = 0;
        double fat = 0;

        List<ConsumableModel> food = [];
        if (widget.meal.toLowerCase() == "snacks") {
          food = (state as HomeLoaded).day.snacks;
        }
        if (widget.meal.toLowerCase() == "dinner") {
          food = (state as HomeLoaded).day.dinner;
        }
        if (widget.meal.toLowerCase() == "breakfast") {
          food = (state as HomeLoaded).day.breakfast;
        }
        if (widget.meal.toLowerCase() == "lunch") {
          food = (state as HomeLoaded).day.lunch;
        }
        for (int i = 0; i < food.length; i++) {
          Map macros = food[i].getMacros();
          kcal += macros['kcal'] as int;
          protein += macros['protein'];
          carb += macros['carb'];
          fat += macros['fat'];
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
                  food[index] is RecipeModel
                      ? RecipeTile(
                          recipe: food[index] as RecipeModel,
                          date: widget.date,
                          tile: Tile.removeDairy,
                          meal: widget.meal,
                        )
                      : FoodTile(
                          food: food[index] as FoodModel,
                          date: widget.date,
                          tile: Tile.removeDairy,
                          meal: widget.meal,
                        ),
                ],
              );
            },
            itemCount: food.length,
          ),
        );
      },
    );
  }
}
