// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';
import 'package:macro_tracker_2/presentation/screens/food/food_info.dart';
import 'package:macro_tracker_2/presentation/widgets/delete.dart';

import '../../constants/strings.dart';

class FoodTile extends StatefulWidget {
  final FoodModel food;
  final Function refresh;

  const FoodTile({
    Key? key,
    required this.refresh,
    required this.food,
  }) : super(key: key);

  @override
  State<FoodTile> createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: MaterialButton(
          onPressed: () async {
            await Navigator.pushNamed(context, Routes.foodInfoRoute,
                arguments: FoodInfo(
                  food: widget.food,
                ));
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
                          widget.food.name,
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
                          "${widget.food.kcal.toString()} KCAL ${widget.food.unit}",
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
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => Delete(
                          id: widget.food.id!,
                          name: widget.food.name,
                        ),
                      );
                      widget.refresh;
                    },
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
