
import 'package:flutter/material.dart';
import '../widgets/text_styles.dart';
import 'app_color.dart';

/**
 * 主题样式设定
 */
class AppTheme {
  static final ThemeData appTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: LatterColor.white,
    brightness: Brightness.light,
    primaryColor: LatterColor.primary,
    cardColor: Colors.white,
    unselectedWidgetColor: LatterColor.textHint,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: LatterColor.primary,
      onPrimary: LatterColor.textOnDark,
      secondary: LatterColor.dartGray,
      onSecondary: LatterColor.textOnDark,
      surface: Colors.white,
      onSurface: LatterColor.textOnLight,
      error: Colors.red,
      onError: Colors.white,
      primaryContainer: LatterColor.tealish,
      secondaryContainer: LatterColor.accent,
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: LatterColor.primary,
      ),
      titleTextStyle: TextStyle(
        color: LatterColor.primary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.white,
      elevation: 0,
    ),

    tabBarTheme: TabBarTheme(
      labelStyle: TextStyles.titleStyle.copyWith(color: LatterColor.primary),
      labelColor: LatterColor.primary,
      unselectedLabelStyle:
      TextStyles.titleStyle.copyWith(color: LatterColor.dartGray),
      unselectedLabelColor: LatterColor.dartGray,
      labelPadding: const EdgeInsets.symmetric(vertical: 12),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: LatterColor.primary,
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LatterColor.primary,
        foregroundColor: Colors.white,
      ),
    ),
  );
}


TextStyle get onPrimaryTitleText { return  TextStyle(color: Colors.white,fontWeight: FontWeight.w600);}
TextStyle get onPrimarySubTitleText { return  TextStyle(color: Colors.white,);}
TextStyle get titleStyle { return  TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold,);}