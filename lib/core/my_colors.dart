import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class MyColors {
  static const green_4CAD79 = Color(0xFF4CAD79);
  static const grey_E4E4E4 = Color(0xFFE4E4E4);
  static const grey_BDBDBD = Color(0xFFBDBDBD);
  static const grey_B0B0B0 = Color(0xFFB0B0B0);
  static const blue_0676E8 = Color(0xFF0676E8);
  static const blue_4285F4 = Color(0xFF4285F4);
  static const grey_EFEFEF = Color(0xFFEFEFEF);
  static const grey_9B9B9B = Color(0xFF9B9B9B);
  static const grey_FAFAFA = Color(0xFFFAFAFA);
  static const grey_A9B9CC = Color(0xFFA9B9CC);

  static const violet_9D70FF = Color(0xFF9D70FF);
  static const violet_7460FF = Color(0xFF7460FF);
  static const grey_68778D = Color(0xFF68778D);
  static const grey_E2E8F0 = Color(0xFFE2E8F0);
  static const grey_F1F4F9 = Color(0xFFF1F4F9);
  static const black_4A5568 = Color(0xFF4A5568);
  static const black_202327 = Color(0xFF202327);
  static const grey_8496AE = Color(0xFF8496AE);
  static const violet_BF87F8 = Color(0xFFBF87F8);
  static const grey_E8E8E8 = Color(0xFFE8E8E8);
  static const grey_939393 = Color(0xFF939393);
  static const blue_007AFF = Color(0xFF007AFF);
  static const violet_7B61FF = Color(0xFF7B61FF);


  static const grey_CBD5E0 = Color(0xFFCBD5E0);
  static const grey_F0F0F0 = Color(0xFFF0F0F0);
  static const red_FF3B30 = Color(0xFFFF3B30);
  static const green_016938 = Color(0xFF016938);
  static const green_36B448 = Color(0xFF36B448);
  static const grey_C6C6C6 = Color(0xFFC6C6C6);
  static const grey_E7EEE7 = Color(0xFFE7EEE7);
  static const green_DEECCB = Color(0xFFDEECCB);
  //36B448
  //275742


  MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color tintColor(Color color, double factor) =>
      Color.fromRGBO(
          tintValue(color.red, factor),
          tintValue(color.green, factor),
          tintValue(color.blue, factor),
          1);

  int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) =>
      Color.fromRGBO(
          shadeValue(color.red, factor),
          shadeValue(color.green, factor),
          shadeValue(color.blue, factor),
          1);
}