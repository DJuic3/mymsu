
import 'package:flutter/material.dart';




class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const TitleView(
      {Key? key,
        this.titleTxt = "",
        this.subTxt= "",
        this.animationController,
        this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
