import 'package:flutter/material.dart';
import 'colors.dart' as app_colors;

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: app_colors.white,
      primaryColor: app_colors.blue,
      dividerColor: app_colors.transparent,
      buttonTheme: const ButtonThemeData(
        buttonColor: app_colors.orange,
      ),
      iconTheme: const IconThemeData(color: app_colors.green));
}