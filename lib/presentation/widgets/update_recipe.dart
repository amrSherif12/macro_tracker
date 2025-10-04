import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/logic/food/food_cubit.dart';
import 'package:testt/presentation/screens/food/create_recipe.dart';
import 'package:testt/presentation/widgets/placeholder/loading_widget.dart';

import '../../data/models/food_model.dart';
import 'ingredients_amounts.dart';

class UpdateRecipe extends StatefulWidget {
  final BuildContext? refreshContext;
  final RecipeModel recipe;

  const UpdateRecipe({super.key, required this.recipe, this.refreshContext});

  @override
  State<UpdateRecipe> createState() => _UpdateRecipeState();
}

class _UpdateRecipeState extends State<UpdateRecipe> {
  bool isLoading = false;

  Widget buildActionButton(String text, VoidCallback onTap) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: MediaQuery
                .sizeOf(context)
                .width - 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ConstColors.sec.withOpacity(0.9), ConstColors.secDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 60),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'F',
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom,
      ),
      child: !isLoading
          ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.85), Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildActionButton("CHANGE INGREDIENTS", () async {
              setState(() => isLoading = true);
              List<FoodModel> ingredients = await BlocProvider
                  .of<FoodCubit>(context)
                  .getFood()
                  .then((val) => (BlocProvider.of<FoodCubit>(context)
                  .state as FoodLoaded).food);
              Navigator.pushNamed(
              context,
              Routes.createRecipeRoute,
              arguments: CreateRecipe(
              ingredients: ingredients,
              refreshContext: widget.refreshContext!,
              recipe: widget.recipe,
              ),
              );
              setState(()
              =>
              isLoading
              =
              false
              );
            }),
            buildActionButton("CHANGE AMOUNTS", () async {
              await showModalBottomSheet(
                backgroundColor: Colors.green[300],
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return IngredientsAmounts(
                    refreshContext: widget.refreshContext,
                    recipe: widget.recipe,
                    create: false,
                  );
                },
                isDismissible: true,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery
                      .of(context)
                      .size
                      .height * 0.8,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
              );
            }),
          ],
        ),
      )
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.85), Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LoadingWidget(),
      ),
    );
  }
}
