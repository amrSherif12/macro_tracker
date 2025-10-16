import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/logic/food/food_cubit.dart';
import 'package:testt/logic/food/recipes_cubit.dart';
import 'package:testt/presentation/screens/food/create_food.dart';
import 'package:testt/presentation/screens/food/create_recipe.dart';
import 'package:testt/presentation/screens/food/food_tab.dart';
import 'package:testt/presentation/screens/food/recipe_tab.dart';

class Food extends StatefulWidget {
  final Tile tile;
  final String? meal;
  final DateTime? date;

  const Food({super.key, required this.tile, this.meal, this.date});

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: ConstColors.main,
        statusBarColor: ConstColors.sec,
      ),
    );
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.main,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: ConstColors.sec,
        toolbarHeight: 10,
        bottom: TabBar(
          controller: tabController,
          unselectedLabelStyle: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 19,
          ),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'f',
          ),
          dividerColor: ConstColors.secMid,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          tabs: const [
            Tab(
              child: Text('My Foods', style: TextStyle(fontFamily: 'f')),
            ),
            Tab(
              child: Text('My Recipes', style: TextStyle(fontFamily: 'f')),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          widget.tile == Tile.addDairy || widget.tile == Tile.removeDairy
              ? FoodTab(tile: widget.tile, date: widget.date, meal: widget.meal)
              : FoodTab(tile: widget.tile, refreshContext: context),
          widget.tile == Tile.addDairy || widget.tile == Tile.removeDairy
              ? RecipeTab(
                  tile: widget.tile,
                  date: widget.date,
                  meal: widget.meal,
                )
              : RecipeTab(tile: widget.tile),
        ],
      ),
      floatingActionButton: widget.tile == Tile.removeFood
          ? FloatingActionButton(
              onPressed: () async {
                if (tabController.index == 0) {
                  await Navigator.pushNamed(
                    context,
                    Routes.createFoodRoute,
                    arguments: CreateFood(),
                  );
                } else {
                  final state = BlocProvider.of<FoodCubit>(context).state;
                  if (state is FoodLoaded || state is FoodNoData) {
                    List<FoodModel> ingredients = [];
                    if (state is FoodLoaded) ingredients = state.food;
                    await Navigator.pushNamed(
                      context,
                      Routes.createRecipeRoute,
                      arguments: CreateRecipe(ingredients: ingredients),
                    );
                  }
                }
              },
              backgroundColor: ConstColors.sec,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
