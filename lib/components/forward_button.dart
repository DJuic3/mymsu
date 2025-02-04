import 'package:flutter/material.dart';

import '../utility/color_utility.dart';




class ForwardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  ForwardButton(
      {required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius:  const BorderRadius.only(
        topLeft:  Radius.circular(30.0),
        bottomLeft:  Radius.circular(30.0),
      ),
      child:  MaterialButton(
          elevation: 12.0,
          minWidth: 70.0,
          color: Color(getColorHexFromStr('#667898')),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),),
          )),
    );
  }
}
