import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/presentation/widgets/placeholder/loading_widget.dart';
import 'package:testt/presentation/widgets/placeholder/no_internet.dart';

import '../../../constants/strings.dart';
import '../../../data/models/food_model.dart';
import '../../../logic/food/food_cubit.dart';
import '../../widgets/food_tile.dart';
import '../../widgets/placeholder/error.dart';

class FoodTab extends StatefulWidget {
  final Function refresh;
  final Tile tile;
  final String? meal;
  final DateTime? date;

  const FoodTab({
    super.key,
    required this.refresh,
    required this.tile,
    this.meal,
    this.date,
  });

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
                  index == 0 ? const SizedBox(height: 20) : const SizedBox(),
                  FoodTile(
                    food: state.food[index],
                    tile: widget.tile,
                    refresh: widget.refresh,
                    date: widget.date,
                    meal: widget.meal,
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
            ),
          );
        } else if (state is FoodNoInternet) {
          return NoInternet();
        } else if (state is FoodError) {
          return ErrorScreen(errorMessage: state.errorMessage);
        } else {
          return LoadingWidget();
        }
      },
    );
  }
}
