import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {

  HeaderText({required this.text, required this.imagePath});

  final String text;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        SizedBox(
          width: size.width *0.01,
        ),
        Container(
          height: 40,
          width: 40,
          decoration:  BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image:  AssetImage(imagePath), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          text,
          style: textTheme.bodyMedium
              ?.copyWith(color: Colors.black87, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

}
