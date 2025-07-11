import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/data/helpers/firestore/day_repository.dart';
import 'package:testt/data/models/consumable_model.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/logic/home/home_cubit.dart';
import 'package:testt/presentation/widgets/textfield.dart';

import '../../data/models/food_model.dart';
import '../../random.dart';

class FoodAmount extends StatefulWidget {
  final ConsumableModel consumable;
  final DateTime date;
  final String meal;
  final BuildContext dairyContext;

  const FoodAmount({
    Key? key,
    required this.consumable,
    required this.meal,
    required this.date,
    required this.dairyContext,
  }) : super(key: key);

  @override
  State<FoodAmount> createState() => _FoodAmountState();
}

class _FoodAmountState extends State<FoodAmount> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
                    label: widget.consumable.name,
                    keyboard: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: controller,
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      widget.consumable is FoodModel
                          ? unitConverter((widget.consumable as FoodModel).unit)
                          : "servings",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'F',
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(color: Colors.greenAccent, width: 30, height: 1),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: GestureDetector(
                onTap: () async {
                  if (controller.text.isNotEmpty) {
                    ConsumableModel consumable = widget.consumable;
                    if (widget.consumable is FoodModel) {
                      (consumable as FoodModel).amount = double.parse(
                        controller.text,
                      );
                    } else {
                      (consumable as RecipeModel).servings = int.parse(
                        controller.text,
                      );
                    }
                    BlocProvider.of<HomeCubit>(
                      widget.dairyContext,
                    ).addFood(context, widget.date, widget.meal, consumable);
                    Navigator.pop(context);
                  }
                },
                child: Material(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
                    child: Text(
                      widget.consumable is FoodModel
                          ? "ADD FOOD"
                          : "ADD RECIPE",
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
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
