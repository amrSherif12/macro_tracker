import 'package:flutter/material.dart';
import 'package:macro_tracker_2/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants/colors.dart';
import '../../../data/models/food_model.dart';
import '../../../data/models/recipe_model.dart';
import '../../widgets/ingredients_tile.dart';

class RecipeInfo extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeInfo({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeInfo> createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  Widget macroBuilder(var val, String text, Color color) {
    return Column(
      children: [
        Text(
          "$val g",
          style: TextStyle(color: color, fontFamily: 'F', fontSize: 22),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontFamily: 'F', fontSize: 17),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double others = widget.recipe.kcal -
        widget.recipe.protein * 4 -
        widget.recipe.carb * 4 -
        widget.recipe.fat * 9;

    List<PieNutrients> chartData = [
      PieNutrients(
          value: (widget.recipe.protein * 4).toInt(), nutrient: "Protein"),
      PieNutrients(value: (widget.recipe.carb * 4).toInt(), nutrient: "Carb"),
      PieNutrients(value: (widget.recipe.fat * 9).toInt(), nutrient: "Fat"),
      PieNutrients(value: others.toInt(), nutrient: "Others"),
    ];

    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 23,
            ),
          ),
          title: Text(
            widget.recipe.name,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'F', fontSize: 23),
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: ConstColors.sec,
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
                  const Center(
                    child: Text(
                      "INGREDIENTS",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'F', fontSize: 30),
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
                                widget.recipe.ingredients.entries
                                    .toList()[index]
                                    .key,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'F',
                                    fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${widget.recipe.amounts[index]} ",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'F',
                                      fontSize: 20),
                                ),
                                Text(
                                  unitConverter(widget
                                      .recipe.ingredients.entries
                                      .toList()[index]
                                      .value),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'F',
                                      fontSize: 20),
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
                          color: Colors.white, fontFamily: 'F', fontSize: 30),
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
                                  fontSize: 22),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "KCAL",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'F',
                                  fontSize: 17),
                            ),
                          ],
                        ),
                        macroBuilder(widget.recipe.protein, "PROTEIN",
                            const Color.fromRGBO(246, 114, 128, 1)),
                        macroBuilder(widget.recipe.carb, "CARB",
                            const Color.fromRGBO(253, 157, 133, 1.0)),
                        macroBuilder(widget.recipe.fat, "FAT",
                            const Color.fromRGBO(255, 217, 159, 1.0)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                      "KCAL DISTRIBUTION",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'F', fontSize: 30),
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
                            fontSize: 17)),
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
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class PieNutrients {
  String nutrient;
  int value;

  PieNutrients({required this.value, required this.nutrient});
}
