import 'package:flutter/material.dart';
import 'package:testt/constants/colors.dart';

class Exercise extends StatefulWidget {
  const Exercise({super.key});

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.main,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: ConstColors.exeMid,
        centerTitle: true,
        title: const Text(
          'My Exercises',
          style: TextStyle(color: Colors.white, fontFamily: "F"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        backgroundColor: ConstColors.exeMid,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
