import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/screens/forget_password_screen/forget_pass_email/forget_pass_email.dart';
import 'package:luminawall/src/features/authentication/screens/forget_password_screen/forget_pass_phone/forget_pass_phone.dart';

import 'package:luminawall/src/constants/colors_strings.dart';
import 'forget_pass_btn_widget.dart';
class ForgetpasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? kJungleMossDark : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Forget Password!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : kJungleMossDark,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                "Select one of the options given below to reset your Password",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 30),
              ForgetPassBtnWidget(
                size: MediaQuery.of(context).size,
                iconbtn: Icons.email_rounded,
                title: "E-Mail",
                subtitle: "Reset via Email Verification",
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const ForgetPassEmail());
                },
              ),
              const SizedBox(height: 15),
              ForgetPassBtnWidget(
                size: MediaQuery.of(context).size,
                iconbtn: Icons.phone_android_rounded,
                title: "Phone-No",
                subtitle: "Reset via Phone Verification",
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const ForgetPassPhone());
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
