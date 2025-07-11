// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/logic/food/food_cubit.dart';
import 'package:testt/presentation/screens/food/food_info.dart';
import 'package:testt/presentation/widgets/delete.dart';
import 'package:testt/presentation/widgets/food_amount.dart';

import '../../constants/strings.dart';
import '../../data/helpers/firestore/day_repository.dart';

class FoodTile extends StatefulWidget {
  final FoodModel food;
  final Tile tile;
  final DateTime? date;
  final String? meal;
  final List<String>? saved;
  final BuildContext? refreshContext;

  const FoodTile({
    super.key,
    required this.food,
    required this.tile,
    this.date,
    this.saved,
    this.meal,
    this.refreshContext,
  });

  @override
  State<FoodTile> createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {

  IconData getIcon(Tile tile) {
    if (widget.tile == Tile.removeFood ||
        widget.tile == Tile.removeDairy) {
      return Icons.delete;
    } else if(tile == Tile.search) {
      if (!widget.saved!.contains(widget.food.id!)) return Icons.bookmark_border;
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
              Routes.foodInfoRoute,
              arguments: FoodInfo(food: widget.food, refreshContext: widget.refreshContext,),
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
                          widget.food.name,
                          style: const TextStyle(
                            fontFamily: "F",
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${widget.food.kcal.toString()} KCAL ${widget.food.unit}",
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
                              name: widget.food.name,
                              delete: () async {
                                await BlocProvider.of<FoodCubit>(widget.refreshContext!).deleteFood(
                                  context,
                                  widget.food.id!,
                                );
                              },
                            ),
                          );
                        } else if (widget.tile == Tile.removeDairy) {
                          await showDialog(
                            context: context,
                            builder: (context) => Delete(
                              name: widget.food.name,
                              delete: () async {
                                await DayRepository.instance.removeFood(
                                  context,
                                  widget.date!,
                                  widget.meal!,
                                  widget.food,
                                );
                              },
                            ),
                          );
                        } else if (widget.tile == Tile.search) {
                          if (widget.saved!.contains(widget.food.id!)) {
                            FoodRepository.instance.saveFood(widget.food.id!, isRecipe: false, unSave: true);
                            widget.saved!.remove(widget.food.id!);
                          } else {
                            FoodRepository.instance.saveFood(widget.food.id!, isRecipe: false);
                            widget.saved!.add(widget.food.id!);
                          }
                          setState(() {});
                        } else {
                          await showModalBottomSheet(
                            backgroundColor: Colors.grey[900],
                            context: context,
                            builder: (context) {
                              return FoodAmount(
                                consumable: widget.food,
                                date: widget.date!,
                                meal: widget.meal!,
                                dairyContext: widget.refreshContext!,
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
