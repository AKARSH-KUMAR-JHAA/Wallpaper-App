import 'package:flutter/material.dart';

import '../../../constants/colors_strings.dart';

class Textformfieldtheme {
  static InputDecorationTheme lighttextformfield = InputDecorationTheme(
      labelStyle: const TextStyle(color: kJungleGreen),
      floatingLabelStyle: const TextStyle(color: kJungleForestGreen),
      prefixIconColor: kJungleGreen,
      fillColor: kJungleCream.withValues(alpha: 0.3),
      filled: true,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: kJungleGreen.withValues(alpha: 0.2), width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: kJungleGreen, width: 2)),
      );

  static InputDecorationTheme darktextformfield = InputDecorationTheme(
    labelStyle: const TextStyle(color: kJungleCream),
    floatingLabelStyle: const TextStyle(color: kJungleEmerald),
    prefixIconColor: kJungleCream,
    fillColor: kJungleMossDark.withValues(alpha: 0.5),
    filled: true,
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: kJungleEmerald.withValues(alpha: 0.2), width: 1)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: kJungleEmerald, width: 2)),
  );
}
