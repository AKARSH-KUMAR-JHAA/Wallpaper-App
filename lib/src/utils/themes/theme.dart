import 'package:flutter/material.dart';
import 'package:login/src/utils/themes/widget_theme/elevated_button_theme.dart';
import 'package:login/src/utils/themes/widget_theme/text_form_field_theme.dart';
import 'package:login/src/utils/themes/widget_theme/outline_button_theme.dart';
import 'package:login/src/utils/themes/widget_theme/text_theme.dart';

class GAppTheme {
  GAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.yellow,
    textTheme: ATextTheme.lightTextTheme,
    elevatedButtonTheme: AelevatedButtonTheme.lightelevatedbuttontheme,
    inputDecorationTheme:Textformfieldtheme.lighttextformfield,
    outlinedButtonTheme: AoutlinedButtonTheme.lightoutlinedbuttontheme
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.yellow,
    textTheme: ATextTheme.darkTextTheme,
      elevatedButtonTheme: AelevatedButtonTheme.darkelevatedbuttontheme,
      inputDecorationTheme:Textformfieldtheme.darktextformfield,
      outlinedButtonTheme: AoutlinedButtonTheme.darkoutlinedbuttontheme
  );
}
