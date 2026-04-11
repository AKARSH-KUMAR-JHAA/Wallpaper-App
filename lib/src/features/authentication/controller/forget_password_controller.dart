import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../screens/dashboard_screen/side_nav_bar/side_nav_bar.dart';
import '../screens/forget_password_screen/forget_pass_otp/forget_pass_otp.dart';
import 'otp_controller.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  final phone = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  var isLoading = false.obs;
  var showPassword = false.obs;

  void sendResetEmail() async {
    String emailStr = email.text.trim();
    if (emailStr.isEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(
          msg: "Please enter your email",
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
        );
      });
      return;
    }
    
    isLoading.value = true;
    try {
      await AuthenticationRepository.instance.sendPasswordResetEmail(emailStr);
      // Wait a bit to show success before potentially navigating or clearing
      await Future.delayed(const Duration(seconds: 1));
      email.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void sendResetOTP() async {
    String phoneStr = phone.text.trim();
    if (phoneStr.isEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(
          msg: "Please enter your phone number",
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
        );
      });
      return;
    }

    isLoading.value = true;
    try {
      // Set phone number in OtpController for display
      final otpController = Get.put(OtpController());
      otpController.phoneNo.value = phoneStr;
      otpController.isForPasswordReset.value = true; // Mark as reset flow

      await AuthenticationRepository.instance.phoneAuthentication(phoneStr);
      Get.to(() => const ForgetPassOtp());
    } finally {
      isLoading.value = false;
    }
  }

  void resetPassword() async {
    String pass = newPassword.text.trim();
    String confirm = confirmPassword.text.trim();

    if (pass.isEmpty || confirm.isEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(
          msg: "All fields are required",
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
        );
      });
      return;
    }

    if (pass != confirm) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(
          msg: "Passwords do not match",
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
        );
      });
      return;
    }

    isLoading.value = true;
    try {
      await AuthenticationRepository.instance.updatePassword(pass);
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(
          msg: "Password updated successfully",
          backgroundColor: kJungleEmerald,
          textColor: Colors.white,
        );
      });
      
      // Delay to let user see success
      await Future.delayed(const Duration(seconds: 2));
      Get.offAll(() => const SideNavBar()); // Redirect to dashboard
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      });
    } finally {
      isLoading.value = false;
    }
  }
}
