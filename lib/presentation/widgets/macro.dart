import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Macro extends StatefulWidget {
  final String macro;
  final double target;
  final double eaten;
  final Color color;
  const Macro(
      {Key? key,
      required this.target,
      required this.eaten,
      required this.macro,
      required this.color})
      : super(key: key);

  @override
  State<Macro> createState() => _MacroState();
}

class _MacroState extends State<Macro> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.macro,
                style: const TextStyle(
                    fontFamily: "F", fontSize: 15, color: Colors.white),
              ),
              Text(
                "${widget.eaten} / ${widget.target} g",
                style: const TextStyle(
                    fontFamily: "F", fontSize: 15, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearPercentIndicator(
                percent: widget.eaten / widget.target,
                lineHeight: 5,
                barRadius: const Radius.circular(50),
                width: MediaQuery.of(context).size.width * 0.8,
                animationDuration: 2100,
                animateFromLastPercent: true,
                animation: true,
                progressColor: widget.color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
