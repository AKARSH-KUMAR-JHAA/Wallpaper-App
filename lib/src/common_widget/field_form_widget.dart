import 'package:flutter/material.dart';
import '../constants/colors_strings.dart';
import '../features/authentication/models/field_form_model.dart';

class FormFieldWidget extends StatefulWidget {
  const FormFieldWidget({super.key, required this.model});

  final Fieldformmodel model;

  @override
  State<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends State<FormFieldWidget> {
  bool obscured = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.model.label.toLowerCase().contains('password');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? kJungleCream.withValues(alpha: 0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        autocorrect: false,
        enableSuggestions: false,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        validator: widget.model.validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return "This field is required";
              }
              return null;
            },
        controller: widget.model.field,
        obscureText: isPassword && obscured,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? kJungleCream : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: widget.model.label,
          labelStyle: TextStyle(
            color: isDark ? kJungleCream.withValues(alpha: 0.6) : Colors.grey[600],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            widget.model.preicon,
            color: isDark ? kJungleEmerald : Theme.of(context).primaryColor,
            size: 22,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscured = !obscured;
                    });
                  },
                  icon: Icon(
                    obscured ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: isDark ? kJungleCream.withValues(alpha: 0.4) : Colors.grey,
                  ),
                )
              : (widget.model.suficon != null
                  ? Icon(widget.model.suficon,
                      size: 20,
                      color: isDark ? kJungleCream.withValues(alpha: 0.4) : Colors.grey)
                  : null),
          // Idle border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: isDark ? kJungleCream.withValues(alpha: 0.1) : Colors.transparent,
            ),
          ),
          // Active focus border
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: kJungleEmerald,
              width: 1.5,
            ),
          ),
          // Error border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}
