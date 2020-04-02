import 'package:flutter/material.dart';

class Config {
  static final Color colorPrimary = Color(0xFF0544FA);
  static final Color colorAccent = Color(0xFFF25369);
  static final Color colorBackground = Colors.white;
  static final Color colorTransparent = Color(0x00000000);

  static final Color colorText = Color(0xFF50525E);
  static final Color colorTextAccent = Color(0xFFC1C2C4);
  static final Color colorTextBold = Color(0xFF161620);
  static final Color colorDanger = Color(0xFFC44E54);

  static final List<ColorGradient> colorsGradient = [
    ColorGradient(Color(0xFF3B90EC), Color(0xFF416FD9)),
    ColorGradient(Color(0xFFFC805E), Color(0xFFFF4F52)),
    ColorGradient(Color(0xFF6CD686), Color(0xFF1EBAB8)),
    ColorGradient(Color(0xFFFD825E), Color(0xFFE47062)),
    ColorGradient(Color(0xFFFF8A5F), Color(0xFFE1954F)),
    ColorGradient(Color(0XFF536976), Color(0XFF292E49)),
    ColorGradient(Color(0XFFffe259), Color(0XFFffa751)),
    ColorGradient(Color(0XFF0052D4), Color(0XFF4364F7)),
    ColorGradient(Color(0XFF4364F7), Color(0XFF6FB1FC)),
    ColorGradient(Color(0XFFee9ca7), Color(0XFFffdde1)),
    ColorGradient(Color(0XFF2193b0), Color(0XFF6dd5ed)),
    ColorGradient(Color(0XFF6b6b83), Color(0XFF3b8d99)),
    ColorGradient(Color(0XFF8E2DE2), Color(0XFF4A00E0)),
    ColorGradient(Color(0XFFf953c6), Color(0XFFb91d73)),
    ColorGradient(Color(0XFF7F7FD5), Color(0XFF86A8E7)),
    ColorGradient(Color(0XFFFBD786), Color(0XFFf7797d)),
  ];

  static height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

class ColorGradient {
  final Color colorOne;
  final Color colorTwo;

  ColorGradient(this.colorOne, this.colorTwo);
}
