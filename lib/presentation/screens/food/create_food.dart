import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/logic/food/food_cubit.dart';
import 'package:testt/presentation/widgets/placeholder/loading_widget.dart';

import '../../../data/helpers/auth_helper.dart';
import '../../widgets/textfield.dart';
import '../../widgets/toast.dart';

class CreateFood extends StatefulWidget {
  final BuildContext foodTabContext;
  const CreateFood({Key? key, required this.foodTabContext}) : super(key: key);

  @override
  State<CreateFood> createState() => _CreateFoodState();
}

class _CreateFoodState extends State<CreateFood> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController kcalCont = TextEditingController();
  TextEditingController proteinCont = TextEditingController();
  TextEditingController carbCont = TextEditingController();
  TextEditingController fatCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  late String unit;
  bool isLoading = false;

  @override
  void initState() {
    unit = Lists.units.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.main,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: ConstColors.sec,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          splashRadius: 20,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Create a food',
              style: TextStyle(color: Colors.white, fontFamily: "F"),
            ),
            isLoading
                ? SmallLoading(isWhite: true)
                : IconButton(
                    onPressed: () async {
                      if (int.parse(kcalCont.text) > 10000) {
                        toastBuilder('Food can\'t exceed 1000 kcal', context);
                      } else if (double.parse(proteinCont.text) * 4 +
                          double.parse(carbCont.text) * 4 +
                          double.parse(fatCont.text) * 9 >
                          int.parse(kcalCont.text)) {
                        toastBuilder(
                          'Macro nutrients are exceeding the calories in the food',
                          context,
                        );
                      } else {
                        isLoading = true;
                        setState(() {});
                        await BlocProvider.of<FoodCubit>(widget.foodTabContext).addFood(context, FoodModel(
                          name: nameCont.text,
                          kcal: int.parse(kcalCont.text),
                          description: descriptionCont.text.trim(),
                          lowerName: nameCont.text.toLowerCase(),
                          unit: unit,
                          uid: AuthenticationHelper
                              .instance
                              .auth
                              .currentUser!
                              .uid,
                          protein: double.parse(proteinCont.text),
                          carb: double.parse(carbCont.text),
                          fat: double.parse(fatCont.text),
                        ),);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.done, color: Colors.white),
                    splashRadius: 20,
                  ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: UnderLineTextField(
                  label: "Food name",
                  keyboard: TextInputType.text,
                  controller: nameCont,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: UnderLineTextField(
                  label: "Brand (optional)",
                  keyboard: TextInputType.text,
                  controller: descriptionCont,
                ),
              ),
            ],
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
                style: const TextStyle(color: Colors.white, fontFamily: "F"),
                underline: Container(height: 1, color: Colors.greenAccent),
                onChanged: (String? value) {
                  unit = value!;
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
        ],
      ),
    );
  }
}
