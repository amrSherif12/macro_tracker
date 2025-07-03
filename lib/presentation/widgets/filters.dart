import 'package:flutter/material.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/data/models/filter_model.dart';

class Filters extends StatefulWidget {
  final FilterModel filters;

  const Filters({super.key, required this.filters});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  late RangeValues kcal;
  late RangeValues protein;
  late RangeValues carb;
  late RangeValues fat;
  late bool filtersOn;
  late bool isRecipe;

  @override
  void initState() {
    kcal = RangeValues(
      widget.filters.kcalStart.toDouble(),
      widget.filters.kcalEnd.toDouble(),
    );
    protein = RangeValues(
      widget.filters.proteinStart.toDouble(),
      widget.filters.proteinEnd.toDouble(),
    );
    carb = RangeValues(
      widget.filters.carbStart.toDouble(),
      widget.filters.carbEnd.toDouble(),
    );
    fat = RangeValues(
      widget.filters.fatStart.toDouble(),
      widget.filters.fatEnd.toDouble(),
    );
    filtersOn = widget.filters.filtersOn;
    isRecipe = widget.filters.isRecipe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstColors.main,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Food',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Radio(
                      value: false,
                      groupValue: isRecipe,
                      onChanged: (val) {
                        isRecipe = false;
                        setState(() {});
                      },
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => states.contains(MaterialState.selected)
                            ? ConstColors.sec
                            : Colors.grey[800]!,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Recipe',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Radio(
                      value: true,
                      groupValue: isRecipe,
                      onChanged: (val) {
                        isRecipe = true;
                        setState(() {});
                      },
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => states.contains(MaterialState.selected)
                            ? ConstColors.sec
                            : Colors.grey[800]!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${kcal.start.toInt()} - ${kcal.end.toInt()} KCAL',
              style: TextStyle(color: Colors.white),
            ),
            RangeSlider(
              min: 0,
              max: 1500,
              values: kcal,
              onChanged: filtersOn
                  ? (val) {
                      kcal = val;
                      setState(() {});
                    }
                  : (val) {},
              inactiveColor: Colors.grey[800],
              activeColor: filtersOn ? ConstColors.sec : Colors.grey[700],
            ),
            Text(
              '${protein.start.toInt()} - ${protein.end.toInt()} PROTEIN',
              style: TextStyle(color: Colors.white),
            ),
            RangeSlider(
              min: 0,
              max: 100,
              values: protein,
              onChanged: filtersOn
                  ? (val) {
                      protein = val;
                      setState(() {});
                    }
                  : (val) {},
              inactiveColor: Colors.grey[800],
              activeColor: filtersOn ? ConstColors.sec : Colors.grey[700],
            ),
            Text(
              '${carb.start.toInt()} - ${carb.end.toInt()} CARB',
              style: TextStyle(color: Colors.white),
            ),
            RangeSlider(
              min: 0,
              max: 100,
              values: carb,
              onChanged: filtersOn
                  ? (val) {
                      carb = val;
                      setState(() {});
                    }
                  : (val) {},
              inactiveColor: Colors.grey[800],
              activeColor: filtersOn ? ConstColors.sec : Colors.grey[700],
            ),
            Text(
              '${fat.start.toInt()} - ${fat.end.toInt()} FAT',
              style: TextStyle(color: Colors.white),
            ),
            RangeSlider(
              min: 0,
              max: 100,
              values: fat,
              onChanged: filtersOn
                  ? (val) {
                      fat = val;
                      setState(() {});
                    }
                  : (val) {},
              inactiveColor: Colors.grey[800],
              activeColor: filtersOn ? ConstColors.sec : Colors.grey[700],
            ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(5),
          ),
          onPressed: () {
            filtersOn = !filtersOn;
            setState(() {});
          },
          color: filtersOn ? ConstColors.secDark : Colors.grey[800],
          child: Text(
            'Filters',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        ClipRRect(
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(5),
            ),
            onPressed: () {
              widget.filters.kcalStart = kcal.start.toInt();
              widget.filters.kcalEnd = kcal.end.toInt();
              widget.filters.proteinStart = protein.start.toInt();
              widget.filters.proteinEnd = protein.end.toInt();
              widget.filters.carbStart = carb.start.toInt();
              widget.filters.carbEnd = carb.end.toInt();
              widget.filters.fatStart = fat.start.toInt();
              widget.filters.fatEnd = fat.end.toInt();
              widget.filters.filtersOn = filtersOn;
              widget.filters.isRecipe = isRecipe;
              Navigator.pop(context, true);
            },
            color: ConstColors.secDark,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
