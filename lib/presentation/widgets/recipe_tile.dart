// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:testt/data/helpers/firestore/day_repository.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/presentation/screens/food/recipe_info.dart';

import '../../constants/strings.dart';
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
    if (widget.tile == Tile.removeFood ||
        widget.tile == Tile.removeDairy) {
      return Icons.delete;
    } else if(tile == Tile.search) {
      if (!widget.saved!.contains(widget.recipe.id!)) return Icons.bookmark_border;
      return Icons.bookmark;
    } else {
      return Icons.add;
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
          color: Colors.grey[800],
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
                        Text(
                          "${widget.recipe.kcal.toString()} KCAL",
                          style: TextStyle(
                            fontFamily: "F",
                            fontSize: 13,
                            color: Colors.grey[300]!,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                                await FoodRepository.instance.deleteFood(
                                  context,
                                  widget.recipe.id!,
                                  isRecipe: true,
                                );
                              },
                            ),
                          );
                          widget.refresh!();
                        } else if (widget.tile == Tile.removeDairy) {
                          await showDialog(
                            context: context,
                            builder: (context) => Delete(
                              name: widget.recipe.name,
                              delete: () async {
                                await DayRepository.instance.removeFood(
                                  context,
                                  widget.date!,
                                  widget.meal!,
                                  widget.recipe,
                                );
                              },
                            ),
                          );
                        }
                        else if (widget.tile == Tile.search) {
                          if (widget.saved!.contains(widget.recipe.id!)) {
                            FoodRepository.instance.saveFood(widget.recipe.id!, isRecipe: true, unSave: true);
                            widget.saved!.remove(widget.recipe.id!);
                          } else {
                            FoodRepository.instance.saveFood(widget.recipe.id!, isRecipe: true);
                            widget.saved!.add(widget.recipe.id!);
                          }
                          setState(() {});
                        } else {
                          await showModalBottomSheet(
                            backgroundColor: Colors.grey[900],
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
                      backgroundColor: Colors.grey[700],
                      child: Icon(
                        getIcon(widget.tile),
                        color: Colors.white,
                      ),
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
