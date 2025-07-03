import 'package:flutter/material.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/data/helpers/firestore/food_repository.dart';
import 'package:testt/data/models/consumable_model.dart';
import 'package:testt/presentation/widgets/placeholder/loading_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Delete extends StatefulWidget {
  final String name;
  final Future<void> Function() delete;
  const Delete({super.key, required this.name, required this.delete});

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstColors.main,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text(
        'Confirm Delete',
        style: TextStyle(color: Colors.white, fontFamily: 'f'),
      ),
      content: Text(
        'Are you sure you want to delete ${widget.name}',
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
        isLoading
            ? SmallLoading()
            : TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  isLoading = true;
                  setState(() {});
                  await widget.delete();
                  Navigator.of(context).pop();
                },
              ),
      ],
    );
  }
}
