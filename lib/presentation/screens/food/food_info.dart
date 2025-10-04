import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/presentation/screens/food/create_food.dart';
import 'package:testt/data/helpers/random.dart';

class FoodInfo extends StatefulWidget {
  final FoodModel food;

  const FoodInfo({Key? key, required this.food})
    : super(key: key);

  @override
  State<FoodInfo> createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  @override
  Widget build(BuildContext context) {
    double others =
        widget.food.kcal -
        widget.food.protein * 4 -
        widget.food.carb * 4 -
        widget.food.fat * 9;

    List<PieNutrients> chartData = [
      PieNutrients(
        value: (widget.food.protein * 4).toInt(),
        nutrient: "Protein",
      ),
      PieNutrients(value: (widget.food.carb * 4).toInt(), nutrient: "Carb"),
      PieNutrients(value: (widget.food.fat * 9).toInt(), nutrient: "Fat"),
      PieNutrients(value: others.toInt(), nutrient: "Others"),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: ConstColors.sec,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 23),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Food Info',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'F',
                fontSize: 23,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.createFoodRoute,
                  arguments: CreateFood(
                    food: widget.food,
                  ),
                );
              },
              icon: Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          // 🍽 Food name & brand
          Container(
            padding: const EdgeInsets.all(20),
            decoration: infoBoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FOOD NAME",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    letterSpacing: 1.5,
                    fontFamily: 'F',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.food.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'F',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "BRAND",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    letterSpacing: 1.5,
                    fontFamily: 'F',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.food.description.isNotEmpty
                      ? widget.food.description!
                      : "No brand",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'F',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 🍗 Macros
          Container(
            padding: const EdgeInsets.all(20),
            decoration: infoBoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "MACROS",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'F',
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      widget.food.unit,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'F',
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    macroCard(
                      "KCAL",
                      widget.food.kcal.toString(),
                      Colors.white,
                    ),
                    macroCard(
                      "PROTEIN",
                      "${widget.food.protein.withoutZeroDecimal()}g",
                      const Color(0xFFF67280),
                    ),
                    macroCard(
                      "CARB",
                      "${widget.food.carb.withoutZeroDecimal()}g",
                      const Color(0xFFFD9D85),
                    ),
                    macroCard(
                      "FAT",
                      "${widget.food.fat.withoutZeroDecimal()}g",
                      const Color(0xFFFFD99F),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 🍩 Doughnut Chart
          Container(
            padding: const EdgeInsets.all(20),
            decoration: infoBoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "KCAL DISTRIBUTION",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'F',
                  ),
                ),
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
                ),
              ],
            ),
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

  BoxDecoration infoBoxDecoration() => BoxDecoration(
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
  );
}

class PieNutrients {
  String nutrient;
  int value;

  PieNutrients({required this.value, required this.nutrient});
}
