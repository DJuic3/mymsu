import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
    required double size,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/home.png',
      selectedImagePath: 'assets/home1.png',
      index: 0,
      isSelected: true,
      animationController: null,
      size: 15,
    ),
    TabIconData(
      imagePath: 'assets/settings.png',
      selectedImagePath: 'assets/settings1.png',
      index: 1,
      isSelected: false,
      animationController: null,
      size: 15,
    ),
    TabIconData(
      imagePath: 'assets/fees.png',
      selectedImagePath: 'assets/fees1.png',
      index: 2,
      isSelected: false,
      animationController: null,
      size: 15,
    ),
    TabIconData(
      imagePath: 'assets/results.png',
      selectedImagePath: 'assets/results1.png',
      index: 3,
      isSelected: false,
      animationController: null,
      size: 15,
    ),
  ];
}
