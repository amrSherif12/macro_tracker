// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';
import 'package:testt/data/helpers/random.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/logic/food/food_cubit.dart';
import 'package:testt/logic/home/home_cubit.dart';
import 'package:testt/presentation/screens/food/food_info.dart';
import 'package:testt/presentation/widgets/delete.dart';
import 'package:testt/presentation/widgets/food_amount.dart';

import '../../constants/strings.dart';


class FoodTile extends StatefulWidget {
  final FoodModel food;
  final Tile tile;
  final DateTime? date;
  final String? meal;
  final List<String>? saved;

  const FoodTile({
    super.key,
    required this.food,
    required this.tile,
    this.date,
    this.saved,
    this.meal,
  });

  @override
  State<FoodTile> createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  IconData getIcon(Tile tile) {
    if (widget.tile == Tile.removeFood || widget.tile == Tile.removeDairy) {
      return Icons.delete;
    } else if (tile == Tile.search) {
      if (!widget.saved!.contains(widget.food.id!))
        return Icons.bookmark_border;
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
              arguments: FoodInfo(food: widget.food),
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
                          widget.tile != Tile.removeDairy
                              ? "${widget.food.kcal.toString()} KCAL ${widget.food.unit}"
                              : "${widget.food.amount!.withoutZeroDecimal().toString()} ${unitConverter(widget.food.unit)}",
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
                                BlocProvider.of<FoodCubit>(
                                  context,
                                ).deleteFood(context, widget.food.id!);
                              },
                            ),
                          );
                        } else if (widget.tile == Tile.removeDairy) {
                          await showDialog(
                            context: context,
                            builder: (context) => Delete(
                              name: widget.food.name,
                              delete: () async {
                                BlocProvider.of<HomeCubit>(context).removeFood(
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
                            BlocProvider.of<FoodCubit>(context).deleteFood(context, widget.food.id!, unSave: true);
                            widget.saved!.remove(widget.food.id!);
                          } else {
                            BlocProvider.of<FoodCubit>(context).saveFood(widget.food);
                            widget.saved!.add(widget.food.id!);
                          }
                          setState(() {});
                        } else {
                          await showModalBottomSheet(
                            backgroundColor: Colors.green[300],
                            context: context,
                            builder: (context) {
                              return FoodAmount(
                                consumable: widget.food,
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
