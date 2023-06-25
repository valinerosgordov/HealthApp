import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/core/my_colors.dart';

enum Categories {
  sport,
  yoga,
  recipes,
  diet,
  massage,
  detox,
}

extension CategoriesExtension on Categories {
  int getIndex() {
    switch (this) {
      case Categories.sport:
        return 0;
      case Categories.yoga:
        return 1;
      case Categories.recipes:
        return 2;
      case Categories.diet:
        return 3;
      case Categories.massage:
        return 4;
      case Categories.detox:
        return 5;
    }
  }

  String getText() {
    switch (this) {
      case Categories.sport:
        return "Тренировки для похудения";
      case Categories.yoga:
        return "Йога";
      case Categories.recipes:
        return "Полезные рецепты";
      case Categories.diet:
        return "Советы нутрициолога";
      case Categories.massage:
        return "Техники массажа";
      case Categories.detox:
        return "Detox";
    }
  }

  Widget getIcon() {
    switch (this) {
      case Categories.sport:
      case Categories.yoga:
      case Categories.recipes:
      case Categories.diet:
      case Categories.massage:
      case Categories.detox:
        return SizedBox(
          child: Center(
            child: SvgPicture.asset(
              "images/" + this.name + ".svg",
              color: MyColors.green_4CAD79,
            ),
          ),
          width: 32,
          height: 32,
        );
    }
  }
}

T enumFromStringOther<T>(Iterable<T> values, String string) {
  return values.firstWhere((e) => describeEnum(e!) == string);
}