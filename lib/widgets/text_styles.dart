
import 'dart:ui';
import 'package:flutter/material.dart';
import '../common/app_color.dart';

class TextStyles {
  TextStyles._();

  static TextStyle get onPrimaryTitleText {
    return TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
  }

  static TextStyle get onPrimarySubTitleText {
    return TextStyle(
      color: Colors.white,
    );
  }

  static TextStyle get titleStyle {
    return TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get subtitleStyle {
    return TextStyle(
        color: LatterColor.textHint, fontSize: 14, fontWeight: FontWeight.bold);
  }

  static TextStyle get userNameStyle {
    return TextStyle(
        color: LatterColor.textHint, fontSize: 14, fontWeight: FontWeight.bold);
  }

  static TextStyle get textStyle14 {
    return TextStyle(
        color: LatterColor.secondary, fontSize: 14, fontWeight: FontWeight.bold);
  }
}