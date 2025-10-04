import 'package:flutter/material.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/data/models/food_model.dart';

class IngredientsTile extends StatefulWidget {
  final FoodModel food;
  final List<String> list;
  IngredientsTile({Key? key, required this.food, required this.list})
    : super(key: key);

  @override
  State<IngredientsTile> createState() => _IngredientsTileState();
}

class _IngredientsTileState extends State<IngredientsTile> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.list.contains(widget.food.id!);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
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
          color: !isChecked ? Colors.grey[850] : ConstColors.secOff,
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
                          style: TextStyle(
                            fontFamily: "F",
                            fontSize: 18,
                            color: !isChecked ? Colors.white : Colors.grey[900],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${widget.food.kcal.toString()} KCAL ${widget.food.unit}",
                          style: TextStyle(
                            fontFamily: "F",
                            fontSize: 13,
                            color: !isChecked
                                ? Colors.grey[300]!
                                : Colors.grey[900],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: FloatingActionButton(
                      mini: true,
                      heroTag: null,
                      onPressed: null,
                      backgroundColor: !isChecked
                          ? Color(0xFF4D4D4D)
                          : ConstColors.sec,
                      child: const Icon(Icons.done, color: Colors.white),
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
