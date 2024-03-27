import 'package:flutter/material.dart';
import 'package:newmsu/utility/app_constant.dart';
import 'package:newmsu/utility/color_utility.dart';

class OnBoardingEnterAnimation {
  OnBoardingEnterAnimation(this.controller)
      : colorAnimation = ColorTween(
    begin: Color(getColorHexFromStr(COLOR_WELCOME)),
    end: Color(getColorHexFromStr(COLOR_LOGIN)),
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ),
  );

  final AnimationController controller;
  final Animation<Color?> colorAnimation;
}
