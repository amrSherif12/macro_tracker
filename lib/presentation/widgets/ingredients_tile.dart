import 'package:flutter/material.dart';
import 'package:macro_tracker_2/constants/colors.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';

class IngredientsTile extends StatefulWidget {
  final FoodModel food;
  final List<String> list;
  IngredientsTile(
      {Key? key,
      required this.food,
      required this.list,})
      : super(key: key);

  @override
  State<IngredientsTile> createState() => _IngredientsTileState();
}

class _IngredientsTileState extends State<IngredientsTile> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.list.contains(widget.food.id!);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: MaterialButton(
          onPressed: () {
            if (!isChecked) {
              widget.list.add(widget.food.id!);
            } else {
              widget.list.remove(widget.food.id!);
            }
            isChecked = !isChecked;
            setState(() {});
          },
          elevation: 10,
          color:
              !isChecked ? Colors.grey[800] : ConstColors.secOff,
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
                          style: TextStyle(
                              fontFamily: "F",
                              fontSize: 20,
                              color: !isChecked
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
                              color: !isChecked
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
                    backgroundColor: !isChecked
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
