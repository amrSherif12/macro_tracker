// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/logic/food/recipes_cubit.dart';
import 'package:testt/presentation/screens/food/recipe_info.dart';

import '../../constants/strings.dart';
import '../../logic/home/home_cubit.dart';
import 'delete.dart';
import 'food_amount.dart';

class RecipeTile extends StatefulWidget {
  final RecipeModel recipe;
  final Tile tile;
  final DateTime? date;
  final String? meal;
  final Function? refresh;
  final List<String>? saved;

  const RecipeTile({
    Key? key,
    required this.recipe,
    required this.tile,
    this.date,
    this.refresh,
    this.meal,
    this.saved,
  }) : super(key: key);

  @override
  State<RecipeTile> createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  IconData getIcon(Tile tile) {
    if (widget.tile == Tile.removeFood || widget.tile == Tile.removeDairy) {
      return Icons.delete;
    } else if (tile == Tile.search) {
      if (!widget.saved!.contains(widget.recipe.id!))
        return Icons.bookmark_border;
      return Icons.bookmark;
    } else {
      return Icons.add;
    }
  }

  IconData getSecIcon(Tile tile) {
    if (widget.tile == Tile.removeDairy) {
      return Icons.edit;
    } else {
      return Icons.star_rate_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          onPressed: () async {
            await Navigator.pushNamed(
              context,
              Routes.recipeInfoRoute,
              arguments: RecipeInfo(recipe: widget.recipe),
            );
          },
          elevation: 10,
          color: Colors.grey[850],
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(3, 13, 3, 13),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe.name,
                          style: const TextStyle(
                            fontFamily: "F",
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              widget.tile != Tile.removeDairy
                                  ? "${widget.recipe.kcal.toString()} KCAL"
                                  : "${widget.recipe.servings.toString()} ${widget.recipe.servings! > 1 ? "servings" : "serving"}",
                              style: TextStyle(
                                fontFamily: "F",
                                fontSize: 13,
                                color: Colors.grey[300]!,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: FloatingActionButton(
                      mini: true,
                      heroTag: null,
                      onPressed: () async {
                        if (widget.tile == Tile.removeFood) {
                          await showDialog(
                            context: context,
                            builder: (context) => Delete(
                              name: widget.recipe.name,
                              delete: () async {
                                await BlocProvider.of<RecipesCubit>(
                                  context,
                                ).deleteRecipe(context, widget.recipe.id!);
                              },
                            ),
                          );
                        } else if (widget.tile == Tile.removeDairy) {
                          await showDialog(
                            context: context,
                            builder: (context) => Delete(
                              name: widget.recipe.name,
                              delete: () async {
                                BlocProvider.of<HomeCubit>(context).removeFood(
                                  context,
                                  widget.date!,
                                  widget.meal!,
                                  widget.recipe,
                                );
                              },
                            ),
                          );
                        } else if (widget.tile == Tile.search) {
                          if (widget.saved!.contains(widget.recipe.id!)) {
                            BlocProvider.of<RecipesCubit>(context).deleteRecipe(context, widget.recipe.id!, unSave: true);
                            widget.saved!.remove(widget.recipe.id!);
                          } else {
                            BlocProvider.of<RecipesCubit>(
                              context,
                            ).saveRecipe(widget.recipe);
                            widget.saved!.add(widget.recipe.id!);
                          }
                          setState(() {});
                        } else {
                          await showModalBottomSheet(
                            backgroundColor: Colors.green[300],
                            context: context,
                            builder: (context) {
                              return FoodAmount(
                                consumable: widget.recipe,
                                date: widget.date!,
                                meal: widget.meal!,
                              );
                            },
                            isDismissible: true,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              ),
                            ),
                          );
                        }
                      },
                      backgroundColor: Color(0xFF4D4D4D),
                      child: Icon(getIcon(widget.tile), color: Colors.white),
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
