import 'package:flutter/material.dart';

class AoutlinedButtonTheme {
  static final lightoutlinedbuttontheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: BorderSide(width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))
    ),
  );

  static final darkoutlinedbuttontheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
        side: BorderSide(width: 1.5,color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))
    ),
  );
}
