import 'package:flutter/material.dart';
import 'package:macro_tracker_2/data/helpers/firestore/day_repository.dart';
import 'package:macro_tracker_2/presentation/widgets/textfield.dart';

import '../../data/models/food_model.dart';
import '../../utils.dart';

class FoodAmount extends StatefulWidget {
  final FoodModel food;
  final DateTime date;
  final String meal;

  const FoodAmount(
      {Key? key, required this.food, required this.meal, required this.date})
      : super(key: key);

  @override
  State<FoodAmount> createState() => _FoodAmountState();
}

class _FoodAmountState extends State<FoodAmount> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: UnderLineTextField(
                      label: widget.food.name,
                      keyboard:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: controller),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      unitConverter(widget.food.unit),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'F',
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      color: Colors.greenAccent,
                      width: 30,
                      height: 1,
                    )
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: GestureDetector(
                onTap: () async {
                  if (controller.text.isNotEmpty) {
                    widget.food.amount = double.parse(controller.text);
                    DayRepository.instance.addFood(
                        context, widget.date, widget.meal, widget.food);
                  }
                  Navigator.pop(context);
                },
                child: Material(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
                    child: Text(
                      "ADD FOOD",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'F',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
