import 'package:flutter/material.dart';

import '../../../constants/colors_strings.dart';

class AoutlinedButtonTheme {
  static final lightoutlinedbuttontheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: kJungleGreen,
        side: const BorderSide(width: 1.5, color: kJungleGreen),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
    ),
  );

  static final darkoutlinedbuttontheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: kJungleEmerald,
        side: const BorderSide(width: 1.5, color: kJungleEmerald),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
    ),
  );
}
