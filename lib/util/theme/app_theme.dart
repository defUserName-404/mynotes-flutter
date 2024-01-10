import 'package:flutter/material.dart';
import 'package:mynotes/util/constants/colors.dart';
import 'package:mynotes/util/theme/custom_theme/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: "Poppins",
      brightness: Brightness.light,
      primaryColor: CustomColors.primary,
      scaffoldBackgroundColor: CustomColors.light,
      textTheme: CustomTextTheme.lightTextTheme);

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: "Poppins",
      brightness: Brightness.dark,
      primaryColor: CustomColors.primary,
      scaffoldBackgroundColor: CustomColors.dark,
      textTheme: CustomTextTheme.darkTextTheme);
}
