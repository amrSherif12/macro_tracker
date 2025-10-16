import 'package:flutter/material.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/logic/food/food_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/presentation/screens/food/food.dart';
import '../food/food_tab.dart';

class AddFood extends StatefulWidget {
  final DateTime date;
  final String meal;
  const AddFood({super.key, required this.date, required this.meal});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.main,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: ConstColors.sec,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Add Food',
          style: TextStyle(fontFamily: 'f', color: Colors.white),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Food(tile: Tile.addDairy, date: widget.date, meal: widget.meal),
    );
  }
}
