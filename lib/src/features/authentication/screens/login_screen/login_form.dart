import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';
import '../../models/Field_form_model.dart';
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
      padding: const EdgeInsets.all(15),
      child: Form(
        key: loginkeu,
        child: Column(
          children: [
            FormFieldWidget(
                model: Fieldformmodel(
                  field: controller.email,
                    label: 'Email',
                    preicon: Icons.email_outlined,
                    )),
            SizedBox(
              height: 10,
            ),
            FormFieldWidget(
                model: Fieldformmodel(
                  field: controller.password,
                    label: 'Password',
                    preicon: Icons.password_rounded,
                    suficon: Icons.remove_red_eye)),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      ForgetpasswordScreen.buildShowModalBottomSheet(context);
                    },
                    child: Text("Forget Password?",
                        style: TextStyle(color: Colors.blue, fontSize: 20)))),
            SizedBox(
                height: 60,
                width: size.width,
                child: ElevatedButton(
                    onPressed: () {
                      if(loginkeu.currentState!.validate()){
                        LoginController.instance.login(controller.email.text.trim(), controller.password.text.trim());
                      }
                    },
                    child: Text(
                      'LOGIN',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )))
          ],
        ),
      ),
    );
  }

}
