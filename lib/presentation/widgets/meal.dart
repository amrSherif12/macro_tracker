import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:macro_tracker_2/constants/colors.dart';
import 'package:macro_tracker_2/data/models/food_model.dart';
import 'package:macro_tracker_2/data/models/recipe_model.dart';

import '../../constants/strings.dart';

class Meal extends StatefulWidget {
  final List<FoodModel> food;
  final List<RecipeModel> recipes;
  final IconData icon;
  final String meal;
  final bool isFree;

  const Meal(
      {super.key,
      required this.icon,
      required this.meal,
      required this.food,
      required this.isFree,
      required this.recipes});

  @override
  State<Meal> createState() => _MealState();
}

class _MealState extends State<Meal> {
  List<String> items = [];
  List<int> itemsKcal = [];
  int totalKcal = 0;

  void kcalCalc() {
    for (int i = 0; i < widget.food.length; i++) {
      String unit = widget.food[i].unit;
      String food = widget.food[i].food;
      double amount = widget.food[i].amount!;
      int kcal = widget.food[i].kcal;
      if (unit == 'per 100 gm' || unit == 'per 100 ml') {
        items.add(food);
        itemsKcal.add((kcal * amount / 100).toInt());
      } else {
        items.add(food);
        itemsKcal.add((kcal * amount).toInt());
      }
    }
    for (int i = 0; i < widget.recipes.length; i++) {
      String recipe = widget.recipes[i].recipe;
      int kcal = widget.recipes[i].kcal;
      items.add(recipe);
      itemsKcal.add(kcal);
    }
    for (int i = 0; i < items.length; i++) {
      totalKcal += itemsKcal[i];
    }
  }

  late bool open;

  @override
  void initState() {
    open = false;
    kcalCalc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[850],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  widget.meal,
                  style: const TextStyle(
                      fontFamily: "F", fontSize: 20, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: FloatingActionButton(
                    onPressed: !widget.isFree
                        ? () {
                            Navigator.pushNamed(context, Routes.addFoodRoute);
                          }
                        : null,
                    heroTag: null,
                    backgroundColor:
                        widget.isFree ? ConstColors.cheat : ConstColors.sec,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            open == true
                ? FadeInDown(
                    from: 40,
                    duration: const Duration(milliseconds: 450),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  items[index],
                                  style: TextStyle(
                                      fontFamily: "F",
                                      fontSize: 20,
                                      color: Colors.grey[300]),
                                ),
                                Text(
                                  itemsKcal[index].toString(),
                                  style: TextStyle(
                                      fontFamily: "F",
                                      fontSize: 20,
                                      color: Colors.grey[400]),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: widget.food.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ),
                  )
                : Container(),
            Column(
              children: [
                Divider(
                  thickness: 2,
                  endIndent: 30,
                  indent: 30,
                  color: Colors.grey[500],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      items.isNotEmpty
                          ? IconButton(
                              splashRadius: 1,
                              icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (child, anim) =>
                                      RotationTransition(
                                        turns: child.key ==
                                                const ValueKey('icon1')
                                            ? Tween<double>(begin: 1, end: 1)
                                                .animate(anim)
                                            : Tween<double>(begin: 0.75, end: 1)
                                                .animate(anim),
                                        child: FadeTransition(
                                            opacity: anim, child: child),
                                      ),
                                  child: open == true
                                      ? const Icon(Icons.keyboard_arrow_up,
                                          color: Colors.white,
                                          size: 30,
                                          key: ValueKey('icon1'))
                                      : const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.white,
                                          size: 30,
                                          key: ValueKey('icon2'),
                                        )),
                              onPressed: () {
                                open = !open;
                                setState(() {});
                              },
                            )
                          : const SizedBox(),
                      const Spacer(),
                      Text(
                        "Total KCAL: $totalKcal",
                        style: const TextStyle(
                            fontFamily: "F", fontSize: 20, color: Colors.white),
                      ),
                      Spacer(
                        flex: items.isNotEmpty ? 2 : 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
