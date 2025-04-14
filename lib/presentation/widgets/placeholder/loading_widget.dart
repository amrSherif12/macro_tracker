import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../constants/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.discreteCircle(
            color: ConstColors.secMid,
            size: 30,
            secondRingColor: ConstColors.secMidOff,
            thirdRingColor: ConstColors.secOff));
  }
}
