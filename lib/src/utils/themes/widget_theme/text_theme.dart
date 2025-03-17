import 'package:flutter/material.dart';

class ATextTheme {
  static TextTheme lightTextTheme = TextTheme(
      bodyMedium: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodySmall: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(
          fontSize: 37, fontWeight: FontWeight.bold, color: Colors.black),
      headlineMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: Colors.black,

      ),
      displaySmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
      displayMedium: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w300,
      color: Colors.white
  )
  );
  static TextTheme darkTextTheme = TextTheme(
      bodyMedium: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodySmall: TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(
          fontSize: 37, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: Colors.white,

      ),
      displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white
      ),
      displayMedium: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w300,
      color: Colors.white
  )
  );
}
