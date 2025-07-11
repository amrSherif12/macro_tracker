import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/logic/food/recipes_cubit.dart';
import 'package:testt/presentation/widgets/textfield.dart';
import 'package:testt/random.dart';

import '../../data/models/food_model.dart';

class IngredientsAmounts extends StatefulWidget {
  final BuildContext? refreshContext;
  final List<FoodModel>? items;
  final bool create;
  final RecipeModel? recipe;

  const IngredientsAmounts({
    Key? key,
    this.items,
    this.recipe,
    required this.create,
    this.refreshContext,
  }) : super(key: key);

  @override
  State<IngredientsAmounts> createState() => _IngredientsAmountsState();
}

class _IngredientsAmountsState extends State<IngredientsAmounts> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    int size = widget.create
        ? widget.items!.length
        : widget.recipe!.ingredients.length;
    for (int i = 0; i < size; i++) {
      controllers.add(TextEditingController());
      if (!widget.create) {
        controllers[i].text = widget.recipe!.ingredients[i]['amount']
            .toString();
      }
    }
    if (!widget.create) {
      nameCont.text = widget.recipe!.name;
      descriptionCont.text = widget.recipe!.description;
    }
    super.initState();
  }

  bool controllersAreNotEmpty(List<TextEditingController> controllers) {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                UnderLineTextField(
                  label: 'Recipe name',
                  keyboard: TextInputType.text,
                  controller: nameCont,
                ),
                UnderLineTextField(
                  label: 'Directions',
                  keyboard: TextInputType.multiline,
                  controller: descriptionCont,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            endIndent: 120,
            indent: 120,
            height: 30,
            color: Colors.grey[800]!,
          ),
          const Center(
            child: Text(
              "INGREDIENTS",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'F',
                fontSize: 25,
              ),
            ),
          ),
          Divider(
            thickness: 2,
            endIndent: 120,
            indent: 120,
            height: 30,
            color: Colors.grey[800]!,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: UnderLineTextField(
                      label: widget.create
                          ? widget.items![index].name
                          : widget.recipe!.ingredients[index]['name'],
                      keyboard: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      controller: controllers[index],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        unitConverter(
                          widget.create
                              ? widget.items![index].unit
                              : widget.recipe!.ingredients[index]['unit'],
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'F',
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        color: Colors.greenAccent,
                        width: 30,
                        height: 1,
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              );
            },
            itemCount: widget.create
                ? widget.items!.length
                : widget.recipe!.ingredients.length,
          ),
          const SizedBox(height: 50),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () async {
                  if (nameCont.text.isNotEmpty &&
                      controllersAreNotEmpty(controllers)) {
                    if (widget.create) {
                      await BlocProvider.of<RecipesCubit>(
                        widget.refreshContext!,
                      ).addRecipe(
                        context,
                        nameCont.text,
                        descriptionCont.text,
                        widget.items!,
                        controllers,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      widget.recipe!.name = nameCont.text;
                      widget.recipe!.description = descriptionCont.text;
                      widget.recipe!.lowerName = nameCont.text.toLowerCase();
                      await BlocProvider.of<RecipesCubit>(
                        widget.refreshContext!,
                      ).updateRecipeAmounts(
                        context,
                        widget.recipe!,
                        controllers,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Material(
                  color: ConstColors.sec,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
                    child: Text(
                      widget.create == true ? "CREATE RECIPE" : "UPDATE RECIPE",
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
        ],
      ),
    );
  }
}
