import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/common_widget/field_form_widget.dart';
import 'package:login/src/common_widget/header_form_widget.dart';
import 'package:login/src/features/authentication/models/Field_form_model.dart';
import 'package:login/src/features/authentication/screens/forget_password_screen/forget_pass_otp/forget_pass_otp.dart';

class ForgetPassEmail extends StatelessWidget {
  const ForgetPassEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            header_form_widget(
              img: "assets/images/forget_pass_images/forget_pass_email.png",
              txt: "Forget Password",
              txt2: "Enter your email below to reset your password",
            ),
            SizedBox(
              height: 22,
            ),
            FormFieldWidget(
                model: Fieldformmodel(
                    label: "Email", preicon: Icons.email_outlined)),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 60,
                width: size.width,
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(ForgetPassOtp());
                    },
                    child: Text(
                      "Next",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )))
          ],
        ),
      ),
    ));
  }
}
