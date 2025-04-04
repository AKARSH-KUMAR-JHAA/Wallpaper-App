import 'package:flutter/material.dart';
import 'package:login/src/common_widget/field_form_widget.dart';
import 'package:login/src/common_widget/header_form_widget.dart';
import 'package:login/src/features/authentication/models/field_form_model.dart';

class ForgetPassPhone extends StatelessWidget {
  const ForgetPassPhone({super.key});

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
            HeaderFormWidget(
              img: "assets/images/forget_pass_images/forget_pass_email.png",
              txt: "Forget Password",
              txt2: "Enter your phone-No below to reset your password",
            ),
            SizedBox(
              height: 22,
            ),
            FormFieldWidget(
                model: Fieldformmodel(
                    label: "Phone-No", preicon: Icons.phone_android_outlined)),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 60,
                width: size.width,
                child: ElevatedButton(
                    onPressed: () {
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
