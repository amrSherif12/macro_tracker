import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_tracker_2/presentation/widgets/placeholder/loading_widget.dart';
import 'package:macro_tracker_2/presentation/widgets/placeholder/no_internet.dart';

import '../../../data/models/food_model.dart';
import '../../../logic/food/food_cubit.dart';
import '../../widgets/food_tile.dart';
import '../../widgets/placeholder/error.dart';

class FoodTab extends StatefulWidget {
  final Function refresh;
  final bool isAdd;
  final String? meal;
  final DateTime? date;

  const FoodTab(
      {super.key,
      required this.refresh,
      required this.isAdd,
      this.meal,
      this.date});

  @override
  State<FoodTab> createState() => _FoodTabState();
}

class _FoodTabState extends State<FoodTab> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCubit, FoodState>(
      builder: (context, state) {
        if (state is FoodLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  index == 0
                      ? const SizedBox(
                          height: 20,
                        )
                      : const SizedBox(),
                  BlocProvider(
                    create: (context) => FoodCubit(),
                    child: FoodTile(
                      food: FoodModel(
                          id: state.food[index].id!,
                          name: state.food[index].name,
                          kcal: state.food[index].kcal,
                          uid: state.food[index].uid,
                          carb: state.food[index].carb,
                          fat: state.food[index].fat,
                          protein: state.food[index].protein,
                          unit: state.food[index].unit),
                      isAdd: widget.isAdd,
                      refresh: widget.refresh,
                      date: widget.date,
                      meal: widget.meal,
                    ),
                  ),
                ],
              );
            },
            itemCount: state.food.length,
          );
        } else if (state is FoodNoData) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 350,
                  child: Image.asset('assets/imgs/nofood.png'),
                ),
                const Text(
                  'No Food Saved',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'f',
                  ),
                ),
                const Text(
                  'You can save food by creating or searching it.',
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
        } else if (state is FoodNoInternet) {
          return NoInternet();
        } else if (state is FoodError) {
          return ErrorScreen(
            errorMessage: state.errorMessage,
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }
}
