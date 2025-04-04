import 'package:flutter/material.dart';

class Textformfieldtheme {
  static InputDecorationTheme lighttextformfield = InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey,),
      floatingLabelStyle: TextStyle(color: Colors.blue),
      prefixIconColor: Colors.black,
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: Colors.black,width: 1,)),
      focusedBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.blue,width: 2)),

      );
  static InputDecorationTheme darktextformfield = InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.grey,),
    floatingLabelStyle: TextStyle(color: Colors.blue),
    prefixIconColor: Colors.white,
    fillColor: Colors.black,
    filled: true,
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: Colors.white,width: 1,)),
    focusedBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.blue,width: 2)),
  );
}
