import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/forget_password_screen/forget_pass_email/forget_pass_email.dart';
import 'package:login/src/features/authentication/screens/forget_password_screen/forget_pass_phone/forget_pass_phone.dart';
import 'forget_pass_btn_widget.dart';
class ForgetpasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return showModalBottomSheet(
      context: context,
      builder: (context) =>
          SizedBox(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Forget Password!",
                    style:
                    Theme
                        .of(context)
                        .textTheme
                        .headlineSmall,
                  ),
                  Text(
                    "Select one of the options given below to reset your Password",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 35),
                  forget_pass_btn_widget(
                    size: size,
                    iconbtn: Icons.email_outlined,
                    title: "E-Mail",
                    subtitle: "Reset via Email Verification",
                    onTap: () {
                      Get.to(ForgetPassEmail());
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  forget_pass_btn_widget(size: size,
                    iconbtn: Icons.phone_android_outlined,
                    title: "Phone-No",
                    subtitle: "Reset via Phone Verification",
                    onTap: () {
                    Get.to(ForgetPassPhone());
                    },)
                ],
              ),
            ),
          ),
    );
  }
}
