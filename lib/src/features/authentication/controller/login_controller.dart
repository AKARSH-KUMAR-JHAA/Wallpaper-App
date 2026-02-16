import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../exception/signup_email_password_failure.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../screens/dashboard_screen/side_nav_bar/side_nav_bar.dart';
import '../screens/forget_password_screen/forget_pass_otp/forget_pass_otp.dart';
import 'otp_controller.dart';
class LoginController extends GetxController {
  static LoginController get instance => Get.find();


  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  /// TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();

  /// TextField Validation

  //Call this Function from Design & it will do the rest
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      
      // Disable automatic redirect
      AuthenticationRepository.instance.canRedirect = false;
      
      await AuthenticationRepository.instance.signInWithEmailAndPassword(email, password);
      
      // Get the UID of the logged-in user
      final uid = AuthenticationRepository.instance.firebaseUser.value?.uid;
      
      if (uid != null) {
        // Fetch user data from Firestore to get phone number
        final snapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();
        
        if (snapshot.exists) {
          final phoneNo = snapshot.data()?['PhoneNo'];
          
          if (phoneNo != null && phoneNo.isNotEmpty) {
            // Set phone number in OtpController for display
            final otpController = Get.put(OtpController());
            otpController.phoneNo.value = phoneNo;
            
            // Trigger Phone Auth and Navigate to OTP Screen
            await AuthenticationRepository.instance.phoneAuthentication(phoneNo);
            
            isLoading.value = false;
            // Use the same OTP screen as signup
            Get.to(() => const ForgetPassOtp());
            return;
          }
        }
      }
      
      // Fallback: If no phone number found or something failed, just go to SideNavBar (or handle error)
      isLoading.value = false;
      AuthenticationRepository.instance.canRedirect = true;
      Get.offAll(() => const SideNavBar());
      
    } catch (e) {
      isLoading.value = false;
      String errorMessage = e is SignUpEmailPasswordFailure ? e.message : e.toString();
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(200),
        colorText: Colors.white,
      );
    }
  }
  Future<void> googleSignIn() async{
    try{
      isGoogleLoading.value = true;
      await AuthenticationRepository.instance.signInWithGoogle();
      isGoogleLoading.value = false;
    }
    catch (e) {
      isGoogleLoading.value = false;
      debugPrint("Google Sign-In Error: $e");
      
      // Use ScaffoldMessenger for maximum stability during platform transitions
      final context = Get.context;
      if (context != null) {
        Future.delayed(const Duration(milliseconds: 600), () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().contains('network_error') 
                    ? 'Network issue detected. Please check your internet.' 
                    : 'Sign-in failed. Please try again.',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red.withValues(alpha: 0.9),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 4),
            ),
          );
        });
      }
    }

  }


}