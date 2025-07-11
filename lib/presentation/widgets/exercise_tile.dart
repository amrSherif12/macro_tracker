// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/logic/food/food_cubit.dart';
import 'package:testt/presentation/screens/food/food_info.dart';

import '../../constants/strings.dart';

class ExerciseTile extends StatefulWidget {
  final FoodModel food;
  const ExerciseTile({Key? key, required this.food}) : super(key: key);

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: MaterialButton(
          onPressed: () async {},
          elevation: 10,
          color: Colors.grey[800],
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.food.name,
                          style: const TextStyle(
                            fontFamily: "F",
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${widget.food.kcal.toString()} KCAL ${widget.food.unit}",
                          style: TextStyle(
                            fontFamily: "F",
                            fontSize: 13,
                            color: Colors.grey[300]!,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                      // await showDialog(
                      //   context: context,
                      //   builder: (context) => BlocProvider(
                      //     create: (context) => MyFoodsCubit(),
                      //     child: RemoveFood(
                      //       id: widget.id,
                      //       name: widget.food,
                      //     ),
                      //   ),
                      // );
                      // BlocProvider.of<MyFoodsCubit>(context).showFood();
                    },
                    backgroundColor: Colors.grey[700],
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
