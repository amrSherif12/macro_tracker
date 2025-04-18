import 'package:flutter/material.dart';
import 'package:macro_tracker_2/constants/colors.dart';
import 'package:macro_tracker_2/data/helpers/firestore/food_repository.dart';

class Delete extends StatelessWidget {
  final String id;
  final String name;
  final bool isRecipe;

  const Delete({
    super.key,
    required this.id,
    required this.name,
    this.isRecipe = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstColors.main,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text(
        'Confirm Delete',
        style: TextStyle(color: Colors.white, fontFamily: 'f'),
      ),
      content: Text(
        'Are you sure you want to delete $name',
        style: TextStyle(color: Colors.white, fontFamily: 'f'),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.red[100], fontFamily: 'f'),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            FoodRepository.instance.deleteFood(context, id, isRecipe: isRecipe);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
