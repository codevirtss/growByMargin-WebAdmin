import 'package:flutter/material.dart';

class ConstantColors {
  final Color mainColor = Color(0XFF92E3A9);
  final Color blackColor = Colors.black;
  final Color greyColor = Colors.grey.shade300;
  final Color whiteColor = Colors.white;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
