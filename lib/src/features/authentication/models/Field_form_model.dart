import 'package:flutter/material.dart';

class Fieldformmodel{
  final String label;
  final IconData preicon;
  final IconData? suficon;
  final TextEditingController? field;
  Fieldformmodel({
    required this.label,
    required this.preicon,
    this.field,
    this.suficon
});
}