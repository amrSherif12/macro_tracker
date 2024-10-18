import 'package:flutter/material.dart';
import 'package:macro_tracker_2/constants/colors.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';

class IngredientsTile extends StatefulWidget {
  final FoodModel food;
  final List<String> list;
  bool isChecked;
  IngredientsTile(
      {Key? key,
      required this.food,
      required this.list,
      required this.isChecked})
      : super(key: key);

  @override
  State<IngredientsTile> createState() => _IngredientsTileState();
}

class _IngredientsTileState extends State<IngredientsTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: MaterialButton(
          onPressed: () {
            if (widget.isChecked == false) {
              widget.list.add(widget.food.id!);
            } else {
              widget.list.remove(widget.food.id!);
            }
            widget.isChecked = !widget.isChecked;
            setState(() {});
          },
          elevation: 10,
          color:
              widget.isChecked == false ? Colors.grey[800] : ConstColors.secOff,
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
                          widget.food.food,
                          style: TextStyle(
                              fontFamily: "F",
                              fontSize: 20,
                              color: widget.isChecked == false
                                  ? Colors.white
                                  : Colors.grey[900]),
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
                              color: widget.isChecked == false
                                  ? Colors.grey[300]!
                                  : Colors.grey[900]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: null,
                    backgroundColor: widget.isChecked == false
                        ? Colors.grey[700]
                        : ConstColors.sec,
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
