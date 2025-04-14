// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_tracker_2/data/models/recipe_model.dart';
import 'package:macro_tracker_2/presentation/screens/food/recipe_info.dart';

import '../../constants/strings.dart';

class RecipeTile extends StatefulWidget {
  final RecipeModel recipe;
  final Function refresh;

  const RecipeTile({
    Key? key,
    required this.refresh,
    required this.recipe,
  }) : super(key: key);

  @override
  State<RecipeTile> createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: MaterialButton(
          onPressed: () async {
            await Navigator.pushNamed(context, Routes.recipeInfoRoute,
                arguments: RecipeInfo(recipe: widget.recipe));
            widget.refresh();
          },
          elevation: 10,
          color: Colors.grey[800],
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe.recipe,
                          style: const TextStyle(
                              fontFamily: "F",
                              fontSize: 20,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.recipe.kcal.toString()} KCAL",
                          style: TextStyle(
                              fontFamily: "F",
                              fontSize: 13,
                              color: Colors.grey[300]!),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {},
                    backgroundColor: Colors.grey[700],
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
