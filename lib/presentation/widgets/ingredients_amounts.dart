import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_tracker_2/data/helpers/auth_helper.dart';
import 'package:macro_tracker_2/data/helpers/firestore/food_repository.dart';
import 'package:macro_tracker_2/data/models/recipe_model.dart';
import 'package:macro_tracker_2/presentation/widgets/textfield.dart';
import 'package:macro_tracker_2/utils.dart';

import '../../data/models/food_model.dart';

class IngredientsAmounts extends StatefulWidget {
  final List<FoodModel> items;
  final bool create;
  final String name;

  const IngredientsAmounts(
      {Key? key, required this.items, required this.create, required this.name})
      : super(key: key);

  @override
  State<IngredientsAmounts> createState() => _IngredientsAmountsState();
}

class _IngredientsAmountsState extends State<IngredientsAmounts> {
  TextEditingController nameCont = TextEditingController();
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    for (int i = 0; i < widget.items.length; i++) {
      controllers.add(TextEditingController());
    }
    nameCont.text = widget.name;
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
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: UnderLineTextField(
              label: 'recipe name',
              keyboard: TextInputType.text,
              controller: nameCont,
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
              style:
                  TextStyle(color: Colors.white, fontFamily: 'F', fontSize: 25),
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
                        label: widget.items[index].name,
                        keyboard: const TextInputType.numberWithOptions(
                            decimal: true),
                        controller: controllers[index]),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        unitConverter(widget.items[index].unit),
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
              );
            },
            itemCount: widget.items.length,
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: GestureDetector(
                onTap: () async {
                  if (nameCont.text.isNotEmpty &&
                      controllersAreNotEmpty(controllers)) {
                    if (widget.create) {
                      FoodRepository.instance.addRecipe(
                        context,
                        nameCont.text,
                        widget.items,
                        controllers,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Material(
                  color: Colors.green,
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
