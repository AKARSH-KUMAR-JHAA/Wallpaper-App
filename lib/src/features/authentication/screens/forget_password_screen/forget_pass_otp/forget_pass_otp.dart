import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/screens/forget_password_screen/forget_header_widget.dart';
import 'package:luminawall/src/features/authentication/controller/otp_controller.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:luminawall/src/constants/image_strings.dart';


import '../../../../../constants/colors_strings.dart';

class ForgetPassOtp extends StatelessWidget {
  const ForgetPassOtp({super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = Get.put(OtpController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => ForgetHeaderWidget(
                  img: forgetPassEmailImage, // Or use a specific OTP image if available
                  title: otpTitle,
                  subtitle: "$otpSubtitle ${otpController.phoneNo.value.isEmpty ? 'your device' : otpController.phoneNo.value}.",
                ),
              ),
              const SizedBox(height: 40),
              OtpTextField(
                numberOfFields: 6,
                fillColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                filled: true,
                cursorColor: Theme.of(context).primaryColor,
                enabledBorderColor: Colors.transparent,
                focusedBorderColor: Theme.of(context).primaryColor,
                showFieldAsBox: true,
                borderRadius: BorderRadius.circular(12),
                fieldWidth: 40,
                handleControllers: (controllers) {
                  // You can use this to sync if needed, but the library also provides onCodeChanged
                },
                onCodeChanged: (code) {
                  otpController.otp.value = code;
                },
                onSubmit: (code) {
                  otpController.otp.value = code;
                  otpController.verifyotp(code);
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (otpController.otp.value.length == 6) {
                      otpController.verifyotp(otpController.otp.value);
                    } else {
                      Get.snackbar("Error", "Please enter 6-digit OTP",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          colorText: Colors.red);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  ),
                  child: const Text(
                    verify,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final canResend = otpController.resendCooldown.value == 0;
                return Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(dintReceiveCode),
                    TextButton(
                      onPressed: canResend
                          ? () {
                              otpController.resendOtp();
                            }
                          : null,
                      child: Text(
                        canResend ? resendCode : "Resend in ${otpController.resendCooldown.value}s",
                        style: TextStyle(
                          color: canResend ? kJungleGreen : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
