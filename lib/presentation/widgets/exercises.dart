import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class Exercises extends StatefulWidget {
  final bool isFree;
  final List exercises;
  const Exercises({super.key, required this.exercises, required this.isFree});

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  late bool open;

  @override
  void initState() {
    open = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[850],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 30,
                ),
                const Text(
                  'Exercise',
                  style: TextStyle(
                      fontFamily: "F", fontSize: 20, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: FloatingActionButton(
                    onPressed: widget.isFree ? () {} : null,
                    heroTag: null,
                    backgroundColor:
                        widget.isFree ? ConstColors.cheat : Colors.blue[600],
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            open == true
                ? FadeInDown(
                    from: 40,
                    duration: const Duration(milliseconds: 450),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.exercises[index].exercise,
                                  style: TextStyle(
                                      fontFamily: "F",
                                      fontSize: 20,
                                      color: Colors.grey[300]),
                                ),
                                Text(
                                  toString(),
                                  style: TextStyle(
                                      fontFamily: "F",
                                      fontSize: 20,
                                      color: Colors.grey[400]),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: widget.exercises.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ),
                  )
                : Container(),
            Column(
              children: [
                Divider(
                  thickness: 2,
                  endIndent: 30,
                  indent: 30,
                  color: Colors.grey[500],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      widget.exercises.isNotEmpty
                          ? IconButton(
                              splashRadius: 1,
                              icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (child, anim) =>
                                      RotationTransition(
                                        turns: child.key ==
                                                const ValueKey('icon1')
                                            ? Tween<double>(begin: 1, end: 1)
                                                .animate(anim)
                                            : Tween<double>(begin: 0.75, end: 1)
                                                .animate(anim),
                                        child: FadeTransition(
                                            opacity: anim, child: child),
                                      ),
                                  child: open == true
                                      ? const Icon(Icons.keyboard_arrow_up,
                                          color: Colors.white,
                                          size: 30,
                                          key: ValueKey('icon1'))
                                      : const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.white,
                                          size: 30,
                                          key: ValueKey('icon2'),
                                        )),
                              onPressed: () {
                                open = !open;
                                setState(() {});
                              },
                            )
                          : const SizedBox(),
                      const Spacer(),
                      Text(
                        "Total KCAL: 0",
                        style: const TextStyle(
                            fontFamily: "F", fontSize: 20, color: Colors.white),
                      ),
                      Spacer(
                        flex: widget.exercises.isNotEmpty ? 2 : 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
