import 'package:flutter/material.dart';
import 'package:login/src/features/authentication/models/field_form_model.dart';
class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget({super.key, required this.model});

  final Fieldformmodel model;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: model.field,
      decoration: InputDecoration(
          label: Text(model.label),
          prefixIcon: Icon(model.preicon),
          suffixIcon: Icon(model.suficon),

      ),
    );
  }
}
