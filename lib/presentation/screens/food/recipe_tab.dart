import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/logic/food/recipes_cubit.dart';
import 'package:testt/presentation/widgets/placeholder/loading_widget.dart';
import 'package:testt/presentation/widgets/placeholder/no_internet.dart';
import 'package:testt/presentation/widgets/recipe_tile.dart';

import '../../../logic/food/food_cubit.dart';
import '../../widgets/placeholder/error.dart';

class RecipeTab extends StatefulWidget {
  final Tile tile;
  final String? meal;
  final DateTime? date;

  const RecipeTab({
    super.key,
    required this.tile,
    this.meal,
    this.date,
  });

  @override
  State<RecipeTab> createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesCubit, RecipesState>(
      builder: (context, state) {
        if (state is RecipesLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  index == 0 ? const SizedBox(height: 20) : const SizedBox(),
                  BlocProvider(
                    create: (context) => FoodCubit(),
                    child: RecipeTileWrapper(
                      recipe: state.recipes[index],
                      tile: widget.tile,
                      date: widget.date,
                      meal: widget.meal,
                    ),
                  ),
                ],
              );
            },
            itemCount: state.recipes.length,
          );
        } else if (state is RecipesNoData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 350,
                    child: Image.asset('assets/imgs/nofood.png'),
                  ),
                  const Text(
                    'No Recipes Saved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'f',
                    ),
                  ),
                  const Text(
                    'You can save recipes by creating or searching them.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'f',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is RecipesNoInternet) {
          return NoInternet();
        } else if (state is RecipesError) {
          return ErrorScreen(errorMessage: state.errorMessage);
        } else {
          return LoadingWidget();
        }
      },
    );
  }
}
