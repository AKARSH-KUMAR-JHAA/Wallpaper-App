import 'package:flutter/material.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/utils/themes/widget_theme/elevated_button_theme.dart';
import 'package:luminawall/src/utils/themes/widget_theme/text_form_field_theme.dart';
import 'package:luminawall/src/utils/themes/widget_theme/outline_button_theme.dart';
import 'package:luminawall/src/utils/themes/widget_theme/text_theme.dart';

import 'package:flutter/services.dart';

class GAppTheme {
  GAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: kJungleGreen,
    scaffoldBackgroundColor: kJungleCream,
    textTheme: ATextTheme.lightTextTheme,
    elevatedButtonTheme: AelevatedButtonTheme.lightelevatedbuttontheme,
    inputDecorationTheme: Textformfieldtheme.lighttextformfield,
    outlinedButtonTheme: AoutlinedButtonTheme.lightoutlinedbuttontheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: kJungleGreen,
      onPrimary: Colors.white,
      secondary: kJungleForestGreen,
      surface: Colors.white,
      onSurface: kJungleMossDark,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: kJungleEmerald,
    scaffoldBackgroundColor: kJungleMossDark,
    textTheme: ATextTheme.darkTextTheme,
    elevatedButtonTheme: AelevatedButtonTheme.darkelevatedbuttontheme,
    inputDecorationTheme: Textformfieldtheme.darktextformfield,
    outlinedButtonTheme: AoutlinedButtonTheme.darkoutlinedbuttontheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: kJungleEmerald,
      onPrimary: Colors.black,
      secondary: kJungleGreen,
      surface: Color(0xFF152A15),
      onSurface: kJungleCream,
    ),
  );
}
