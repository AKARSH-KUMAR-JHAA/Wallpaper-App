import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/models/Field_form_model.dart';
import 'package:login/src/features/authentication/controller/signup_controller.dart';
import 'package:login/src/features/authentication/models/user_model.dart';
import '../../../../common_widget/field_form_widget.dart';
import '../forget_password_screen/forget_pass_otp/forget_pass_otp.dart';

class form_field extends StatelessWidget {
  const form_field({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controllers = Get.put(SignUpController());
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Form(
        child: Column(
          children: [
            FormFieldWidget(
                model: Fieldformmodel(
                    field: controllers.fullName,
                    label: 'Full Name',
                    preicon: Icons.account_circle_outlined)),
            SizedBox(
              height: 10,
            ),
            FormFieldWidget(
                model: Fieldformmodel(
                    field: controllers.email,
                    label: 'Enter Your Email',
                    preicon: Icons.email_outlined)),
            SizedBox(
              height: 10,
            ),
            FormFieldWidget(
                model: Fieldformmodel(
                    field: controllers.phoneNo,
                    label: "Phone Number",
                    preicon: Icons.phone_android_outlined)),
            SizedBox(
              height: 10,
            ),
            FormFieldWidget(
                model: Fieldformmodel(
                    field: controllers.password,
                    label: 'Password',
                    preicon: Icons.password_outlined)),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: size.width,
              height: 65,
              child: ElevatedButton(
                  onPressed: () {
                    var fn = controllers.fullName.text.toString();
                    var el = controllers.email.text.toString();
                    var pN = controllers.phoneNo.text.toString();
                    var pd = controllers.password.text.toString();
                    if (fn != '' && el != '' && pN != '' && pd != '') {
                      final user = UserModel(
                          fullName: controllers.fullName.text.trim(),
                          email: controllers.email.text.trim(),
                          phoneNo: controllers.phoneNo.text.trim(),
                          password: controllers.password.text.trim());

                      SignUpController.instance.creatUser(user);
                      // SignUpController.instance
                      //   .PhoneAuthentication(controllers.phoneNo.text);
                      // Get.to(() => const ForgetPassOtp());
                    }
                    else {
                      Get.snackbar("Empty", "please fill All the field",
                          backgroundColor: Colors.red.withOpacity(0.1),
                          colorText: Colors.red,
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  child: Text("sign up".toUpperCase(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium)),
            )
          ],
        ),
      ),
    );
  }
}
