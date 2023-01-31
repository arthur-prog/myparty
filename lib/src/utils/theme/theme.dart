import 'package:flutter/material.dart';
import 'package:my_party/src/constants/colors.dart';
import 'package:my_party/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:my_party/src/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:my_party/src/utils/theme/widget_themes/text_field_theme.dart';
import 'package:my_party/src/utils/theme/widget_themes/text_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    brightness: Brightness.light,
    textTheme: AppTextTheme.lightTextTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: MyTextFormFieldTheme.lighInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    brightness: Brightness.dark,
    textTheme: AppTextTheme.darkTextTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: MyTextFormFieldTheme.darkInputDecorationTheme,
  );
}