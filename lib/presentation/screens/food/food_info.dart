import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_tracker_2/constants/colors.dart';
import 'package:macro_tracker_2/constants/strings.dart';
import 'package:macro_tracker_2/data/helpers/auth_helper.dart';
import 'package:macro_tracker_2/logic/food/food_info_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../data/models/food_model.dart';
import '../../../logic/food/food_cubit.dart';
import '../../widgets/textfield.dart';

class FoodInfo extends StatefulWidget {
  final String id;
  const FoodInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<FoodInfo> createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController kcalCont = TextEditingController();
  TextEditingController proteinCont = TextEditingController();
  TextEditingController carbCont = TextEditingController();
  TextEditingController fatCont = TextEditingController();
  late String unit;

  @override
  void initState() {
    unit = Lists.units.first;
    BlocProvider.of<FoodInfoCubit>(context).getFood(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: ConstColors.sec,
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
          title: Row(
            children: [
              const Expanded(
                child: Text(
                  'Food Info',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'F', fontSize: 23),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () async {
                  if (kcalCont.text.isNotEmpty &&
                      nameCont.text.isNotEmpty &&
                      proteinCont.text.isNotEmpty &&
                      carbCont.text.isNotEmpty &&
                      fatCont.text.isNotEmpty) {
                    await BlocProvider.of<FoodInfoCubit>(context).saveFood(
                        context,
                        FoodInfoModel(
                            id: widget.id,
                            food: nameCont.text,
                            kcal: int.parse(kcalCont.text),
                            unit: unit,
                            uid: AuthenticationHelper
                                .instance.auth.currentUser!.uid,
                            protein: double.parse(proteinCont.text),
                            carb: double.parse(carbCont.text),
                            fat: double.parse(fatCont.text)));
                  }
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 27,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'F', fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<FoodInfoCubit, FoodInfoState>(
          builder: (context, state) {
            if (state is FoodInfoLoaded) {
              nameCont.text = state.food.food;
              kcalCont.text = state.food.kcal.toString();
              proteinCont.text = state.food.protein.toString();
              carbCont.text = state.food.carb.toString();
              fatCont.text = state.food.fat.toString();
              unit = state.food.unit;
              double others = state.food.kcal -
                  state.food.protein * 4 -
                  state.food.carb * 4 -
                  state.food.fat * 9;

              List<PieNutrients> chartData = [
                PieNutrients(
                    value: (state.food.protein * 4).toInt(),
                    nutrient: "Protein"),
                PieNutrients(
                    value: (state.food.carb * 4).toInt(), nutrient: "Carb"),
                PieNutrients(
                    value: (state.food.fat * 9).toInt(), nutrient: "Fat"),
                PieNutrients(value: others.toInt(), nutrient: "Others"),
              ];
              return Column(
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
                              value: unit,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Colors.white54,
                              ),
                              elevation: 16,
                              dropdownColor: Colors.grey[800],
                              style: const TextStyle(
                                  color: Colors.white, fontFamily: "F"),
                              underline: Container(
                                height: 1,
                                color: Colors.greenAccent,
                              ),
                              onChanged: (String? value) {
                                unit = value!;
                              },
                              items: Lists.units.map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: UnderLineTextField(
                                label: "Protein",
                                keyboard: const TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: proteinCont,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: UnderLineTextField(
                                label: "Carb",
                                keyboard: const TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: carbCont,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: UnderLineTextField(
                                label: "Fat",
                                keyboard: const TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: fatCont,
                              ),
                            ),
                          ],
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
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is FoodInfoNoInternet) {
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
