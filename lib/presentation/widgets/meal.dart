import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/data/helpers/random.dart';
import 'package:testt/data/models/consumable_model.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/presentation/screens/home/add_food.dart';
import 'package:testt/presentation/screens/home/meal_info.dart';

import '../../../constants/strings.dart';
import '../../logic/food/food_cubit.dart';
import '../../logic/food/recipes_cubit.dart';

class MealWrapper extends StatelessWidget {
  final List<ConsumableModel> consumables;
  final IconData icon;
  final String meal;
  final bool isFree;
  final DateTime date;

  const MealWrapper({
    super.key,
    required this.icon,
    required this.meal,
    required this.consumables,
    required this.isFree,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<FoodCubit>()),
        BlocProvider.value(value: context.read<RecipesCubit>()),
      ],
      child: Meal(
        icon: icon,
        meal: meal,
        consumables: consumables,
        isFree: isFree,
        date: date,
      ),
    );
  }
}

class Meal extends StatefulWidget {
  final List<ConsumableModel> consumables;
  final IconData icon;
  final String meal;
  final bool isFree;
  final DateTime date;

  const Meal({
    super.key,
    required this.icon,
    required this.meal,
    required this.consumables,
    required this.isFree,
    required this.date,
  });

  @override
  State<Meal> createState() => _MealState();
}

class _MealState extends State<Meal> {
  int totalKcal = 0;

  void kcalCalc() {
    totalKcal = 0;
    for (int i = 0; i < widget.consumables.length; i++) {
      totalKcal += widget.consumables[i].getMacros()['kcal'] as int;
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
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.035),
      child: GestureDetector(
        onTap: () async {
          if (widget.consumables.isNotEmpty) {
            await Navigator.pushNamed(
              context,
              Routes.mealInfoRoute,
              arguments: MealInfo(
                meal: widget.meal,
                food: widget.consumables,
                date: widget.date,
              ),
            );
          } else {
            await Navigator.pushNamed(
              context,
              Routes.addFoodRoute,
              arguments: AddFood(date: widget.date, meal: widget.meal),
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon, title and add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        widget.meal,
                        style: const TextStyle(
                          fontFamily: "F",
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        Routes.addFoodRoute,
                        arguments: AddFood(
                          date: widget.date,
                          meal: widget.meal,
                        ),
                      );
                    },
                    heroTag: null,
                    mini: true,
                    backgroundColor: widget.isFree
                        ? ConstColors.cheat
                        : ConstColors.sec,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),

              if (open) const SizedBox(height: 16),

              // Food items list
              if (open)
                FadeInDown(
                  from: 40,
                  duration: const Duration(milliseconds: 450),
                  child: ListView.builder(
                    itemCount: widget.consumables.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.consumables[index].name,
                            style: TextStyle(
                              fontFamily: "F",
                              fontSize: 16,
                              color: Colors.grey[300],
                            ),
                          ),
                          Text(
                            widget.consumables[index] is FoodModel
                                ? "${(widget.consumables[index] as FoodModel).amount?.withoutZeroDecimal()} ${unitConverter((widget.consumables[index] as FoodModel).unit)}"
                                : widget.consumables[index] is RecipeModel
                                ? "${(widget.consumables[index] as RecipeModel).servings} servings"
                                : "Quick KCAL",
                            style: TextStyle(
                              fontFamily: "F",
                              fontSize: 15,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Divider and total kcal
              Divider(thickness: 1.5, color: Colors.white.withOpacity(0.08)),

              const SizedBox(height: 10),
              Row(
                children: [
                  if (widget.consumables.isNotEmpty)
                    IconButton(
                      splashRadius: 1,
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, anim) => RotationTransition(
                          turns: Tween<double>(
                            begin: 0.75,
                            end: 1,
                          ).animate(anim),
                          child: FadeTransition(opacity: anim, child: child),
                        ),
                        child: open
                            ? const Icon(
                                Icons.keyboard_arrow_up,
                                key: ValueKey('icon1'),
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.keyboard_arrow_down,
                                key: ValueKey('icon2'),
                                color: Colors.white,
                              ),
                      ),
                      onPressed: () {
                        setState(() => open = !open);
                      },
                    ),
                  const Spacer(),
                  Text(
                    "Total KCAL: $totalKcal",
                    style: const TextStyle(
                      fontFamily: "F",
                      fontSize: 17,
                      color: Colors.white,
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
