import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../constants/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: ConstColors.secMid,
        size: 30,
      ),
    );
  }
}

class SmallLoading extends StatelessWidget {
  final bool isWhite;
  const SmallLoading({super.key, this.isWhite = false});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.threeArchedCircle(
      color: isWhite ? Colors.white : ConstColors.sec,
      size: 25,
    );
  }
}
