import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/logic/food/recipes_cubit.dart';
import 'package:testt/presentation/widgets/textfield.dart';
import 'package:testt/data/helpers/random.dart';

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
    if (!widget.create || widget.recipe != null) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.85), Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recipe Info',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'F',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  UnderLineTextField(
                    label: 'Recipe name',
                    keyboard: TextInputType.text,
                    controller: nameCont,
                  ),
                  const SizedBox(height: 10),
                  UnderLineTextField(
                    label: 'Directions (optional)',
                    keyboard: TextInputType.multiline,
                    controller: descriptionCont,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "INGREDIENTS",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'F',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.create
                  ? widget.items!.length
                  : widget.recipe!.ingredients.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Expanded(
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
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          Text(
                            unitConverter(
                              widget.create
                                  ? widget.items![index].unit
                                  : widget.recipe!.ingredients[index]['unit'],
                            ),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'F',
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            color: Colors.greenAccent,
                            width: 25,
                            height: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Center(
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
                        id: widget.recipe?.id,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                      if (widget.recipe != null) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
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
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstColors.sec,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                    shadowColor: ConstColors.sec.withOpacity(0.5),
                  ),
                  onPressed: () async {
                    if (nameCont.text.isNotEmpty &&
                        controllersAreNotEmpty(controllers)) {
                      if (widget.create) {
                        await BlocProvider.of<RecipesCubit>(context).addRecipe(
                          context,
                          nameCont.text,
                          descriptionCont.text,
                          widget.items!,
                          controllers,
                          id: widget.recipe?.id,
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                        if (widget.recipe != null) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      } else {
                        widget.recipe!.name = nameCont.text;
                        widget.recipe!.description = descriptionCont.text;
                        widget.recipe!.lowerName = nameCont.text.toLowerCase();
                        await BlocProvider.of<RecipesCubit>(
                          context,
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
                  icon: const Icon(Icons.check),
                  label: Text(
                    widget.create && widget.recipe == null
                        ? "Create Recipe"
                        : "Update Recipe",
                    style: const TextStyle(
                      fontFamily: 'F',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
