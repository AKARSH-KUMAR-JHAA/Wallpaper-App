import 'package:flutter/material.dart';

import '../../../constants/colors_strings.dart';

class AelevatedButtonTheme{
  static final lightelevatedbuttontheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kJungleGreen,
      foregroundColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
    ),
  );

  static final darkelevatedbuttontheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: kJungleEmerald,
        foregroundColor: Colors.black,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
    ),
  );

}