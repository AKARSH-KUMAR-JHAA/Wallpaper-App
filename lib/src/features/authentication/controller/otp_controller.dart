import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../repository/user_repository/user_repository.dart';
import '../models/user_model.dart';
import '../screens/dashboard_screen/side_nav_bar/side_nav_bar.dart';
import '../screens/forget_password_screen/reset_password_screen.dart';

class OtpController extends GetxController {
  static OtpController get instance => Get.find();

  var otp = "".obs;
  var phoneNo = "".obs;
  var isForPasswordReset = false.obs;
  var isForSignup = false.obs;
  UserModel? signupUser;
  
  var resendCooldown = 0.obs;
  var isLoading = false.obs;
  final userRepo = Get.put(UserRepository());

  void resendOtp() async {
    if (resendCooldown.value > 0) return;
    
    await AuthenticationRepository.instance.phoneAuthentication(phoneNo.value);
    
    // Start 60s cooldown
    resendCooldown.value = 60;
    _startTimer();
    
    Fluttertoast.showToast(
        msg: "OTP Sent: Verification code has been resent to ${phoneNo.value}",
        backgroundColor: kJungleEmerald,
        textColor: Colors.white,
    );
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (resendCooldown.value > 0) {
        resendCooldown.value--;
        _startTimer();
      }
    });
  }

  void verifyotp(String code) async {
    if (isLoading.value) return;
    
    try {
      isLoading.value = true;
      // 1. Verify the phone number (This signs the user in with Phone)
      var isVerified = await AuthenticationRepository.instance.verifyotp(code);
      
      if (isVerified) {
        if (isForPasswordReset.value) {
          isLoading.value = false;
          Get.off(() => const ResetPasswordScreen());
        } else if (isForSignup.value && signupUser != null) {
          // If we are here, the user is signed in with Phone.
          // Now we link the Email/Password to this Phone user.
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              debugPrint("Linking Email/Pass to user: ${user.uid}");
              
              // Create Email Credential
              final emailCredential = EmailAuthProvider.credential(
                email: signupUser!.email,
                password: signupUser!.password,
              );

              // Link Email/Password to the current Phone-authenticated user
              await user.linkWithCredential(emailCredential);
              
              // Update Display Name
              await user.updateDisplayName(signupUser!.fullName);
              
              // Refresh Auth Repository state to catch the new displayName
              await AuthenticationRepository.instance.refreshUser();
              
              debugPrint("Updating Firestore for user: ${user.uid}");
              
              // Save to Firestore
              await userRepo.createUser(signupUser!, user.uid);
              
              // Allow navigation
              AuthenticationRepository.instance.canRedirect = true;
              
              // Force navigation to home
              debugPrint("Navigating to SideNavBar");
              isLoading.value = false;
              Get.offAll(() => const SideNavBar());
            } else {
              throw "Verification succeeded but no user found to link.";
            }
          } catch (e) {
            isLoading.value = false;
            debugPrint("Signup Verification Final Step Error: $e");
            
            String errorMsg = e.toString();
            if (errorMsg.contains('email-already-in-use')) {
              errorMsg = "This email is already registered. Logging you in.";
              Fluttertoast.showToast(
                  msg: errorMsg,
                  backgroundColor: Colors.orange.withValues(alpha: 0.9),
                  textColor: Colors.white,
              );
            } else {
              Fluttertoast.showToast(
                  msg: "Signup notice: $errorMsg",
                  backgroundColor: Colors.orange.withValues(alpha: 0.8),
                  textColor: Colors.white,
              );
            }
            
            // Still try to go home if they are verified but linking had an issue (maybe already exists)
            AuthenticationRepository.instance.canRedirect = true;
            Get.offAll(() => const SideNavBar());
          }
        } else {
          // Standard login logic (e.g. from forget password or standard login)
          isLoading.value = false;
          AuthenticationRepository.instance.canRedirect = true;
          Get.offAll(() => const SideNavBar());
        }
      } else {
        isLoading.value = false;
        Fluttertoast.showToast(
            msg: "Error: Invalid OTP. Please try again.",
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            textColor: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("Overall Verification Error: $e");
      Fluttertoast.showToast(
          msg: "Error: Verification failed: ${e.toString()}",
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
      );
    }
  }
}