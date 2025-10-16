import 'package:flutter/material.dart';
import 'package:testt/presentation/widgets/ingredients_tile.dart';
import 'package:testt/presentation/widgets/toast.dart';

import '../../../data/models/food_model.dart';
import '../../../data/models/recipe_model.dart';
import '../../widgets/ingredients_amounts.dart';

class CreateRecipe extends StatefulWidget {
  final List<FoodModel> ingredients;
  final RecipeModel? recipe;

  const CreateRecipe({super.key, required this.ingredients, this.recipe});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  TextEditingController controller = TextEditingController();
  List<String> chosen = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
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
                    style: TextStyle(color: Colors.white, fontFamily: "F"),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (chosen.length >= 2) {
                      await showModalBottomSheet(
                        backgroundColor: Colors.green[300],
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return IngredientsAmounts(
                            items: widget.ingredients
                                .where((food) => chosen.contains(food.id))
                                .toList(),
                            create: true,
                            recipe: widget.recipe,
                          );
                        },
                        isDismissible: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
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
                  icon: const Icon(Icons.done, color: Colors.white),
                  splashRadius: 20,
                ),
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
                    borderSide: BorderSide(width: 1, color: Colors.green[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(width: 1, color: Colors.green[300]!),
                  ),
                  label: const Text('Search for an ingredient'),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'F',
                  ),
                ),
                style: const TextStyle(fontFamily: 'F', color: Colors.white),
                cursorColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: widget.ingredients.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    index == 0 ? const SizedBox(height: 20) : const SizedBox(),
                    IngredientsTile(
                      food: widget.ingredients[index],
                      list: chosen,
                    ),
                  ],
                );
              },
              itemCount: widget.ingredients.length,
            )
          : Center(
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
                      'To create a recipe, you need to have food saved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'f',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
