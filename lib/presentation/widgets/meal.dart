import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/data/models/consumable_model.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/logic/home/home_cubit.dart';
import 'package:testt/presentation/screens/home/add_food.dart';
import 'package:testt/presentation/screens/home/meal_info.dart';

import '../../constants/strings.dart';

class Meal extends StatefulWidget {
  final List<ConsumableModel> food;
  final IconData icon;
  final String meal;
  final bool isFree;
  final DateTime date;
  final BuildContext dairyContext;

  const Meal({
    super.key,
    required this.icon,
    required this.meal,
    required this.food,
    required this.isFree,
    required this.date,
    required this.dairyContext,
  });

  @override
  State<Meal> createState() => _MealState();
}

class _MealState extends State<Meal> {
  List<String> items = [];
  List<int> itemsKcal = [];
  int totalKcal = 0;

  void kcalCalc() {
    totalKcal = 0;
    for (int i = 0; i < widget.food.length; i++) {
      items.add(widget.food[i].name);
      itemsKcal.add(widget.food[i].getMacros()['kcal']);
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
      child: GestureDetector(
        onTap: () async {
          if (widget.food.isNotEmpty) {
            await Navigator.pushNamed(
              context,
              Routes.mealInfoRoute,
              arguments: MealInfo(
                meal: widget.meal,
                food: widget.food,
                date: widget.date,
                dairyContext: widget.dairyContext,
              ),
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[850],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 30),
                  Text(
                    widget.meal,
                    style: const TextStyle(
                      fontFamily: "F",
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: FloatingActionButton(
                      onPressed: () async {
                        await Navigator.pushNamed(
                          context,
                          Routes.addFoodRoute,
                          arguments: AddFood(
                            dairyContext: widget.dairyContext,
                            date: widget.date,
                            meal: widget.meal,
                          ),
                        );
                      },
                      heroTag: null,
                      backgroundColor: widget.isFree
                          ? ConstColors.cheat
                          : ConstColors.sec,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    items[index],
                                    style: TextStyle(
                                      fontFamily: "F",
                                      fontSize: 20,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  Text(
                                    itemsKcal[index].toString(),
                                    style: TextStyle(
                                      fontFamily: "F",
                                      fontSize: 20,
                                      color: Colors.grey[400],
                                    ),
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
                                        turns:
                                            child.key == const ValueKey('icon1')
                                            ? Tween<double>(
                                                begin: 1,
                                                end: 1,
                                              ).animate(anim)
                                            : Tween<double>(
                                                begin: 0.75,
                                                end: 1,
                                              ).animate(anim),
                                        child: FadeTransition(
                                          opacity: anim,
                                          child: child,
                                        ),
                                      ),
                                  child: open == true
                                      ? const Icon(
                                          Icons.keyboard_arrow_up,
                                          color: Colors.white,
                                          size: 30,
                                          key: ValueKey('icon1'),
                                        )
                                      : const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.white,
                                          size: 30,
                                          key: ValueKey('icon2'),
                                        ),
                                ),
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
                            fontFamily: "F",
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(flex: items.isNotEmpty ? 2 : 1),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
