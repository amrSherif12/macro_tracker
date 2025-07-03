import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/data/helpers/auth_helper.dart';
import 'package:testt/presentation/widgets/placeholder/loading_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../data/helpers/firestore/food_repository.dart';
import '../../../data/models/food_model.dart';
import '../../../logic/food/food_cubit.dart';
import '../../widgets/textfield.dart';
import '../../widgets/toast.dart';

class FoodInfo extends StatefulWidget {
  final FoodModel food;

  const FoodInfo({Key? key, required this.food}) : super(key: key);

  @override
  State<FoodInfo> createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController kcalCont = TextEditingController();
  TextEditingController proteinCont = TextEditingController();
  TextEditingController carbCont = TextEditingController();
  TextEditingController fatCont = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    nameCont.text = widget.food.name;
    kcalCont.text = widget.food.kcal.toString();
    proteinCont.text = widget.food.protein.toString();
    carbCont.text = widget.food.carb.toString();
    fatCont.text = widget.food.fat.toString();
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 23),
        ),
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Food Info',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'F',
                  fontSize: 23,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 20),
            isLoading
                ? SmallLoading(isWhite: true)
                : GestureDetector(
                    onTap: () async {
                      if (kcalCont.text.isNotEmpty &&
                          nameCont.text.isNotEmpty &&
                          proteinCont.text.isNotEmpty &&
                          carbCont.text.isNotEmpty &&
                          fatCont.text.isNotEmpty) {
                        FoodModel food = FoodModel(
                          id: widget.food.id,
                          name: nameCont.text,
                          kcal: int.parse(kcalCont.text),
                          unit: widget.food.unit,
                          uid: AuthenticationHelper
                              .instance
                              .auth
                              .currentUser!
                              .uid,
                          protein: double.parse(proteinCont.text),
                          carb: double.parse(carbCont.text),
                          fat: double.parse(fatCont.text),
                        );
                        if (food.kcal > 1000) {
                          toastBuilder('Food can\'t exceed 1000 kcal', context);
                        }
                        if (food.protein * 4 + food.carb * 4 + food.fat * 9 >
                            food.kcal) {
                          toastBuilder(
                            'Macro nutrients are exceeding the calories in the food',
                            context,
                          );
                        } else {
                          isLoading = true;
                          setState(() {});
                          await FoodRepository.instance.updateFood(
                            context,
                            food,
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.edit, color: Colors.white, size: 27),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                UnderLineTextField(
                  label: "Food name",
                  keyboard: TextInputType.text,
                  controller: nameCont,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: UnderLineTextField(
                        label: "Calories",
                        keyboard: TextInputType.number,
                        controller: kcalCont,
                      ),
                    ),
                    DropdownButton<String>(
                      value: widget.food.unit,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Colors.white54,
                      ),
                      elevation: 16,
                      dropdownColor: Colors.grey[800],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "F",
                      ),
                      underline: Container(
                        height: 1,
                        color: Colors.greenAccent,
                      ),
                      onChanged: (String? value) {
                        widget.food.unit = value!;
                        setState(() {});
                      },
                      items: Lists.units.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 1),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: UnderLineTextField(
                        label: "Protein",
                        keyboard: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: proteinCont,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: UnderLineTextField(
                        label: "Carb",
                        keyboard: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: carbCont,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: UnderLineTextField(
                        label: "Fat",
                        keyboard: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: fatCont,
                      ),
                    ),
                  ],
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
                      fontSize: 30,
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
                Row(
                  children: [
                    Expanded(
                      child: SfCircularChart(
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
                            xValueMapper: (PieNutrients data, _) =>
                                data.nutrient,
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
                const SizedBox(height: 20),
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
