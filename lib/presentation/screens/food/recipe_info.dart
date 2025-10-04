import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testt/logic/food/food_cubit.dart';
import 'package:testt/presentation/widgets/update_recipe.dart';
import 'package:testt/data/helpers/random.dart';

import '../../../constants/colors.dart';
import '../../../data/models/recipe_model.dart';

class RecipeInfo extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeInfo({Key? key, required this.recipe})
    : super(key: key);

  @override
  State<RecipeInfo> createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
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
        backgroundColor: ConstColors.sec,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.green[300],
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  constraints: const BoxConstraints(maxHeight: 240),
                  builder: (_) => BlocProvider(
                    create: (context) => FoodCubit(),
                    child: UpdateRecipe(
                      recipe: widget.recipe,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.edit, color: Colors.white, size: 27),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          // Recipe Name + Description
          _infoBox(
            children: [
              _label("RECIPE NAME"),
              const SizedBox(height: 6),
              Text(widget.recipe.name, style: _titleText()),
              const SizedBox(height: 20),
              _label("DIRECTIONS"),
              const SizedBox(height: 6),
              Text(
                widget.recipe.description.isNotEmpty
                    ? widget.recipe.description
                    : "No Directions Provided",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'F',
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Ingredients List
          _infoBox(
            children: [
              _label("INGREDIENTS"),
              const SizedBox(height: 16),
              ...widget.recipe.ingredients.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'F',
                            fontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${(item['amount'] as double).withoutZeroDecimal()} ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'F',
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            unitConverter(item['unit']),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'F',
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),

          const SizedBox(height: 30),

          // Macros
          _infoBox(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_label("MACROS"), _label("per serving")],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  macroCard(
                    "KCAL",
                    widget.recipe.kcal.toString(),
                    Colors.white,
                  ),
                  macroCard(
                    "PROTEIN",
                    "${widget.recipe.protein.withoutZeroDecimal()}g",
                    const Color(0xFFF67280),
                  ),
                  macroCard(
                    "CARB",
                    "${widget.recipe.carb.withoutZeroDecimal()}g",
                    const Color(0xFFFD9D85),
                  ),
                  macroCard(
                    "FAT",
                    "${widget.recipe.fat.withoutZeroDecimal()}g",
                    const Color(0xFFFFD99F),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Chart
          _infoBox(
            children: [
              _label("KCAL DISTRIBUTION"),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: SfCircularChart(
                  palette: const [
                    Color(0xFFF67280),
                    Color(0xFFFDA189),
                    Color(0xFFFFD99F),
                    Colors.white,
                  ],
                  legend: const Legend(
                    isVisible: true,
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
                      xValueMapper: (data, _) => data.nutrient,
                      yValueMapper: (data, _) => data.value,
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
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget macroCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(color: color, fontFamily: 'F', fontSize: 22),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontFamily: 'F',
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _infoBox({required List<Widget> children}) {
    return Container(
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
        children: children,
      ),
    );
  }

  TextStyle _titleText() =>
      const TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'F');

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white60,
        fontSize: 13,
        letterSpacing: 1.5,
        fontFamily: 'F',
      ),
    );
  }
}

class PieNutrients {
  String nutrient;
  int value;

  PieNutrients({required this.value, required this.nutrient});
}
