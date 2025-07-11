import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testt/presentation/widgets/update_recipe.dart';
import 'package:testt/random.dart';

import '../../../constants/colors.dart';
import '../../../data/models/recipe_model.dart';

class RecipeInfo extends StatefulWidget {
  final RecipeModel recipe;
  final BuildContext? refreshContext;
  const RecipeInfo({Key? key, required this.recipe, this.refreshContext})
    : super(key: key);

  @override
  State<RecipeInfo> createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  Widget macroBuilder(double val, String text, Color color) {
    return Column(
      children: [
        Text(
          "${val.withoutZeroDecimal()} g",
          style: TextStyle(color: color, fontFamily: 'F', fontSize: 22),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'F',
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    nameCont.text = widget.recipe.name;
    descriptionCont.text = widget.recipe.description ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double others =
        widget.recipe.kcal -
        widget.recipe.protein * 4 -
        widget.recipe.carb * 4 -
        widget.recipe.fat * 9;

    List<PieNutrients> chartData = [
      PieNutrients(
        value: (widget.recipe.protein * 4).toInt(),
        nutrient: "Protein",
      ),
      PieNutrients(value: (widget.recipe.carb * 4).toInt(), nutrient: "Carb"),
      PieNutrients(value: (widget.recipe.fat * 9).toInt(), nutrient: "Fat"),
      PieNutrients(value: others.toInt(), nutrient: "Others"),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: ConstColors.sec,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 23),
        ),
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Recipe Info',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'F',
                  fontSize: 23,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  backgroundColor: Colors.grey[900],
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return UpdateRecipe(
                      refreshContext: widget.refreshContext,
                      recipe: widget.recipe,
                    );
                  },
                  isDismissible: true,
                  constraints: BoxConstraints(maxHeight: 240),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                );
              },
              child: const Row(
                children: [Icon(Icons.edit, color: Colors.white, size: 27)],
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Divider(
                  thickness: 2,
                  endIndent: 100,
                  indent: 100,
                  height: 30,
                  color: Colors.grey[800]!,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.recipe.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'F',
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  endIndent: 100,
                  indent: 100,
                  height: 30,
                  color: Colors.grey[800]!,
                ),
                widget.recipe.description.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.recipe.description,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                          "No Directions Provided",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),

                Divider(
                  thickness: 2,
                  endIndent: 100,
                  indent: 100,
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
                  endIndent: 100,
                  indent: 100,
                  height: 30,
                  color: Colors.grey[800]!,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.recipe.ingredients[index]['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'F',
                                fontSize: 19,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${(widget.recipe.ingredients[index]['amount'] as double).withoutZeroDecimal()} ",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'F',
                                  fontSize: 19,
                                ),
                              ),
                              Text(
                                unitConverter(
                                  widget.recipe.ingredients[index]['unit'],
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'F',
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: widget.recipe.ingredients.length,
                ),
                Divider(
                  thickness: 2,
                  endIndent: 100,
                  indent: 100,
                  height: 30,
                  color: Colors.grey[800]!,
                ),
                const Center(
                  child: Text(
                    "MACROS",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'F',
                      fontSize: 25,
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  endIndent: 100,
                  indent: 100,
                  height: 30,
                  color: Colors.grey[800]!,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.recipe.kcal.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'F',
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "KCAL",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'F',
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      macroBuilder(
                        widget.recipe.protein,
                        "PROTEIN",
                        const Color.fromRGBO(246, 114, 128, 1),
                      ),
                      macroBuilder(
                        widget.recipe.carb,
                        "CARB",
                        const Color.fromRGBO(253, 157, 133, 1.0),
                      ),
                      macroBuilder(
                        widget.recipe.fat,
                        "FAT",
                        const Color.fromRGBO(255, 217, 159, 1.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  thickness: 2,
                  endIndent: 100,
                  indent: 100,
                  height: 30,
                  color: Colors.grey[800]!,
                ),
                const Center(
                  child: Text(
                    "KCAL DISTRIBUTION",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'F',
                      fontSize: 25,
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  endIndent: 100,
                  indent: 100,
                  height: 30,
                  color: Colors.grey[800]!,
                ),
                SfCircularChart(
                  palette: const [
                    Color.fromRGBO(246, 114, 128, 1),
                    Color.fromRGBO(253, 157, 133, 1.0),
                    Color.fromRGBO(255, 217, 159, 1.0),
                    Color.fromRGBO(255, 255, 255, 1.0),
                  ],
                  legend: const Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.scroll,
                    iconHeight: 20,
                    iconWidth: 20,
                    textStyle: TextStyle(
                      fontFamily: "F",
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  series: <CircularSeries>[
                    DoughnutSeries<PieNutrients, String>(
                      dataSource: chartData,
                      xValueMapper: (PieNutrients data, _) => data.nutrient,
                      yValueMapper: (PieNutrients data, _) => data.value,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: "F",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PieNutrients {
  String nutrient;
  int value;

  PieNutrients({required this.value, required this.nutrient});
}
