import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:login/src/common_widget/header_form_widget.dart';
import 'package:login/src/features/authentication/controller/otp_controller.dart';

class ForgetPassOtp extends StatelessWidget {
  const ForgetPassOtp({super.key});

  @override

  Widget build(BuildContext context) {
    Get.put(OtpController());
  late String otp;
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeaderFormWidget(
                txt: "Enter Code",
                txt2: "Enter 6-digit otp Here:",
                img: "assets/images/forget_pass_images/forget_pass_email.png",
              ),
              SizedBox(
                height: 20,
              ),
              OtpTextField(
                numberOfFields: 6,
                fillColor: Colors.grey.shade300,
                filled: true,
                obscureText: true,
                onSubmit: (code) {
                  otp=code;
                  OtpController.instance.verifyotp(otp);
                },
              ),
              SizedBox(height: 30,),
              SizedBox(
                  height: 60,
                  width: size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        OtpController.instance.verifyotp( otp);
                      },
                      child: Text(
                        "Next",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )))
            ],
          ),
        ),
      )),
    ));
  }
}
