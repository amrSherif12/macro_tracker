import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_tracker_2/logic/food/recipe_info_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:macro_tracker_2/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants/colors.dart';
import '../../../data/models/food_model.dart';

import '../../widgets/ingredients_tile.dart';

class RecipeInfo extends StatefulWidget {
  final String id;

  const RecipeInfo({Key? key, required this.id}) : super(key: key);

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
  void initState() {
    BlocProvider.of<RecipeInfoCubit>(context).getRecipe(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: BlocBuilder<RecipeInfoCubit, RecipeInfoState>(
          builder: (context, state) {
            if (state is RecipeInfoLoaded) {
              double others = state.recipe.kcal -
                  state.recipe.protein * 4 -
                  state.recipe.carb * 4 -
                  state.recipe.fat * 9;

              List<PieNutrients> chartData = [
                PieNutrients(
                    value: (state.recipe.protein * 4).toInt(),
                    nutrient: "Protein"),
                PieNutrients(
                    value: (state.recipe.carb * 4).toInt(), nutrient: "Carb"),
                PieNutrients(
                    value: (state.recipe.fat * 9).toInt(), nutrient: "Fat"),
                PieNutrients(value: others.toInt(), nutrient: "Others"),
              ];
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    color: Colors.green,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 23,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                state.recipe.recipe,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'F',
                                    fontSize: 23),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                                color: Colors.white,
                                fontFamily: 'F',
                                fontSize: 30),
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
                              padding:
                                  const EdgeInsets.fromLTRB(30, 15, 30, 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      state.recipe.ingredients[index].food,
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
                                        "${state.recipe.amounts[index]} ",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'F',
                                            fontSize: 20),
                                      ),
                                      Text(
                                        unitConverter(state
                                            .recipe.ingredients[index].unit),
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
                          itemCount: state.recipe.ingredients.length,
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
                                fontSize: 30),
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
                                    state.recipe.kcal.toString(),
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
                              macroBuilder(state.recipe.protein, "PROTEIN",
                                  const Color.fromRGBO(246, 114, 128, 1)),
                              macroBuilder(state.recipe.carb, "CARB",
                                  const Color.fromRGBO(253, 157, 133, 1.0)),
                              macroBuilder(state.recipe.fat, "FAT",
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
                                color: Colors.white,
                                fontFamily: 'F',
                                fontSize: 30),
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
                              xValueMapper: (PieNutrients data, _) =>
                                  data.nutrient,
                              yValueMapper: (PieNutrients data, _) =>
                                  data.value,
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
              );
            } else if (state is RecipeInfoNoInternet) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 350,
                      child: Image.asset('assets/imgs/nointernet.png'),
                    ),
                    const Text(
                      'No Internet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'f',
                      ),
                    ),
                    const Text(
                      'Try reloading the page or checking you internet connection.',
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
            } else {
              return Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: ConstColors.secMid,
                      size: 30,
                      secondRingColor: ConstColors.secMidOff,
                      thirdRingColor: ConstColors.secOff));
            }
          },
        ));
  }
}

class PieNutrients {
  String nutrient;
  int value;

  PieNutrients({required this.value, required this.nutrient});
}
