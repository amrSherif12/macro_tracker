import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_tracker_2/data/helpers/auth_helper.dart';
import 'package:macro_tracker_2/logic/food/food_cubit.dart';
import 'package:macro_tracker_2/presentation/widgets/ingredients_tile.dart';
import 'package:macro_tracker_2/presentation/widgets/placeholder/error.dart';
import 'package:macro_tracker_2/presentation/widgets/placeholder/loading_widget.dart';
import 'package:macro_tracker_2/presentation/widgets/placeholder/no_internet.dart';
import 'package:macro_tracker_2/presentation/widgets/toast.dart';
import '../../../constants/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/models/food_model.dart';
import '../../widgets/ingredients_amounts.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({super.key});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  TextEditingController controller = TextEditingController();
  List<String> chosen = [];
  List<FoodModel> food = [];

  @override
  void initState() {
    BlocProvider.of<FoodCubit>(context).getFood();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 150,
        backgroundColor: Colors.green[600],
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white,
                  ),
                  splashRadius: 20,
                ),
                const FittedBox(
                  child: Text(
                    'Choose the ingredients',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "F",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (chosen.length >= 2) {
                      showModalBottomSheet(
                        backgroundColor: Colors.grey[900],
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return IngredientsAmounts(
                            items: food
                                .where((food) => chosen.contains(food.id))
                                .toList(),
                            create: true,
                            name: '',
                          );
                        },
                        isDismissible: true,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.8),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                      );
                    } else {
                      toastBuilder('Chose at least 2 ingredients', context);
                    }
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  splashRadius: 20,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          BorderSide(width: 1, color: Colors.green[300]!)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          BorderSide(width: 1, color: Colors.green[300]!)),
                  label: const Text('Search for an ingredient'),
                  labelStyle:
                      const TextStyle(color: Colors.white, fontFamily: 'F'),
                ),
                style: const TextStyle(fontFamily: 'F', color: Colors.white),
                cursorColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<FoodCubit, FoodState>(
        builder: (context, state) {
          if (state is FoodLoaded) {
            food = state.food;
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    index == 0
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox(),
                    IngredientsTile(
                      food: food[index],
                      list: chosen,
                    ),
                  ],
                );
              },
              itemCount: state.food.length,
            );
          } else if (state is FoodNoData) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 350,
                    child: Image.asset('assets/imgs/nofood.png'),
                  ),
                  const Text(
                    'No Food Saved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'f',
                    ),
                  ),
                  const Text(
                    'You can save food by creating or searching it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'f',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ));
          } else if (state is FoodNoInternet) {
            return NoInternet();
          } else if (state is FoodError) {
            return ErrorScreen(errorMessage: state.errorMessage);
          } else {
            return LoadingWidget();
          }
        },
      ),
    );
  }
}
