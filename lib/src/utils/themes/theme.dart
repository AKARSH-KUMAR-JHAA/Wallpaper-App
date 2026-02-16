import 'package:flutter/material.dart';
import 'package:luminawall/src/utils/themes/widget_theme/elevated_button_theme.dart';
import 'package:luminawall/src/utils/themes/widget_theme/text_form_field_theme.dart';
import 'package:luminawall/src/utils/themes/widget_theme/outline_button_theme.dart';
import 'package:luminawall/src/utils/themes/widget_theme/text_theme.dart';

class GAppTheme {
  GAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    textTheme: ATextTheme.lightTextTheme,
    elevatedButtonTheme: AelevatedButtonTheme.lightelevatedbuttontheme,
    inputDecorationTheme: Textformfieldtheme.lighttextformfield,
    outlinedButtonTheme: AoutlinedButtonTheme.lightoutlinedbuttontheme,
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.black87,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    textTheme: ATextTheme.darkTextTheme,
    elevatedButtonTheme: AelevatedButtonTheme.darkelevatedbuttontheme,
    inputDecorationTheme: Textformfieldtheme.darktextformfield,
    outlinedButtonTheme: AoutlinedButtonTheme.darkoutlinedbuttontheme,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.white70,
    ),
  );
}
