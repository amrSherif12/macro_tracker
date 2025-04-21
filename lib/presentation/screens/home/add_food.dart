import 'package:flutter/material.dart';
import 'package:macro_tracker_2/constants/colors.dart';
import 'package:macro_tracker_2/logic/food/food_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_tracker_2/presentation/screens/food/food.dart';
import '../food/food_tab.dart';

class AddFood extends StatefulWidget {
  final DateTime date;
  final String meal;
  const AddFood({super.key, required this.date, required this.meal});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {

  void refreshFoodTab() {
    BlocProvider.of<FoodCubit>(context).getFood(isRefresh: true);
  }

  @override
  void initState() {
    BlocProvider.of<FoodCubit>(context).getFood();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.main,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ConstColors.sec,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Add Food', style: TextStyle(fontFamily: 'f', color: Colors.white),),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Food(isAdd: true, date: widget.date, meal: widget.meal,),
    );
  }
}


