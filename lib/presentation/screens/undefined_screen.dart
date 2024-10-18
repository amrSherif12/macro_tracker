import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class Undefined extends StatelessWidget {
  const Undefined({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ConstColors.secDark, ConstColors.sec],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Text(
            "Undefined screen",
            style:
                TextStyle(fontFamily: 'F', fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
