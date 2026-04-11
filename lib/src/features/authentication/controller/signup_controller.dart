import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../repository/user_repository/user_repository.dart';
import '../models/user_model.dart';
import '../screens/forget_password_screen/forget_pass_otp/forget_pass_otp.dart';
import 'otp_controller.dart';


class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final isLoading = false.obs;

  //TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  final conpassword = TextEditingController();
  final fullPhoneNo = "".obs;

  // Field Visibility States
  final showEmail = false.obs;
  final showPhone = false.obs;
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;
  final showSubmit = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to track progress
    fullName.addListener(() => showEmail.value = fullName.text.length >= 3);
    email.addListener(() => showPhone.value = GetUtils.isEmail(email.text));
    // Phone listener is now handled via onChanged in IntlPhoneField
    // phoneNo.addListener(() => showPassword.value = GetUtils.isPhoneNumber(phoneNo.text));
    password.addListener(() => showConfirmPassword.value = password.text.length >= 6);
    conpassword.addListener(() => showSubmit.value = conpassword.text == password.text && conpassword.text.isNotEmpty);
  }

  final userRepo = Get.put(UserRepository());

  // Main registration function
  Future<void> registerUser(UserModel user) async {
    try {
      isLoading.value = true;
      
      // 0. Set data in OtpController for later creation
      final otpController = Get.put(OtpController());
      otpController.phoneNo.value = user.phoneNo;
      otpController.signupUser = user; // Store user details
      otpController.isForSignup.value = true;
      otpController.isForPasswordReset.value = false;

      // Disable automatic redirect for now
      AuthenticationRepository.instance.canRedirect = false;

      // 1. Trigger Phone Auth immediately (The account creation will happen in OtpController after verification)
      await AuthenticationRepository.instance.phoneAuthentication(user.phoneNo);
      
      isLoading.value = false;
      Get.to(() => const ForgetPassOtp());

    } catch (e) {
      isLoading.value = false;
      AuthenticationRepository.instance.canRedirect = true;
      
      String errorMessage = e.toString().replaceAll('SignUpEmailPasswordFailure: ', '');
      if (errorMessage.contains('email-already-in-use')) {
        // ... (existing error handling)
        Future.delayed(const Duration(milliseconds: 500), () {
          Fluttertoast.showToast(
            msg: "Account Exists: This email is already registered.",
            backgroundColor: Colors.orange.withValues(alpha: 0.9),
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG,
          );
        });
            
        await AuthenticationRepository.instance.phoneAuthentication(user.phoneNo);
        Get.to(() => const ForgetPassOtp());
        return;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        Fluttertoast.showToast(
          msg: "Registration Failed: $errorMessage",
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      });
    }
  }


}