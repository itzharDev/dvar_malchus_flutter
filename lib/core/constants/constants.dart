import 'package:flutter/material.dart';

class DMColors {
  static const MaterialColor primaryColor =
      MaterialColor(_dvarmalchuspalettePrimaryValue, <int, Color>{
    50: Color(0xFFE6E6E7),
    100: Color(0xFFC0C1C3),
    200: Color(0xFF96989B),
    300: Color(0xFF6B6F72),
    400: Color(0xFF4C5054),
    500: Color(_dvarmalchuspalettePrimaryValue),
    600: Color(0xFF272C30),
    700: Color(0xFF212529),
    800: Color(0xFF1B1F22),
    900: Color(0xFF101316),
  });
  static const int _dvarmalchuspalettePrimaryValue = 0xFF2C3136;

  static const MaterialColor dvarmalchuspaletteAccent =
      MaterialColor(_dvarmalchuspaletteAccentValue, <int, Color>{
    100: Color(0xFF5CADFF),
    200: Color(_dvarmalchuspaletteAccentValue),
    400: Color(0xFF007AF5),
    700: Color(0xFF006EDB),
  });
  static const int _dvarmalchuspaletteAccentValue = 0xFF2994FF;
}
