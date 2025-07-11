import 'package:flutter/material.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/data/models/recipe_model.dart';

import 'ingredients_amounts.dart';

class UpdateRecipe extends StatefulWidget {
  final BuildContext? refreshContext;
  final RecipeModel recipe;
  const UpdateRecipe({super.key, required this.recipe, this.refreshContext});

  @override
  State<UpdateRecipe> createState() => _UpdateRecipeState();
}

class _UpdateRecipeState extends State<UpdateRecipe> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () async {},
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width - 50,
                  child: Material(
                    color: ConstColors.sec,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
                      child: Center(
                        child: Text(
                          "CHANGE INGREDIENTS",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'F',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    backgroundColor: Colors.grey[900],
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
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width - 50,
                  child: Material(
                    color: ConstColors.sec,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
                      child: Center(
                        child: Text(
                          "CHANGE AMOUNTS",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'F',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
