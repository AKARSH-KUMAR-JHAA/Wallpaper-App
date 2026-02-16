import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';
import '../../models/field_form_model.dart';
import '../forget_password_screen/forget_options_menu/forget_pass_model_bottom_sheet.dart';
import '../../../../common_widget/field_form_widget.dart';

class Loginform extends StatelessWidget {
  const Loginform({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final loginkeu = GlobalObjectKey<FormState>(LoginController);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Form(
        key: loginkeu,
        child: Column(
          children: [
            const SizedBox(height: 20),
            FormFieldWidget(
                model: Fieldformmodel(
              field: controller.email,
              label: 'Email',
              preicon: Icons.email_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) return "Email is required";
                if (!GetUtils.isEmail(value)) return "Enter a valid email";
                return null;
              },
            )),
            const SizedBox(height: 15),
            FormFieldWidget(
                model: Fieldformmodel(
                    field: controller.password,
                    label: 'Password',
                    preicon: Icons.lock_rounded,
                    suficon: Icons.remove_red_eye,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Password is required";
                      return null;
                    })),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      ForgetpasswordScreen.buildShowModalBottomSheet(context);
                    },
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ))),
            const SizedBox(height: 20),
            SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (loginkeu.currentState!.validate()) {
                        LoginController.instance.login(controller.email.text.trim(),
                            controller.password.text.trim());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
