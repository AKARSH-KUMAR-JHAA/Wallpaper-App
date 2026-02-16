import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/features/authentication/controller/forget_password_controller.dart';
import 'package:luminawall/src/constants/image_strings.dart';
import 'package:luminawall/src/features/authentication/screens/forget_password_screen/forget_header_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgetPasswordController>();

    return Scaffold(
      backgroundColor: kJungleMossDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: kJungleCream),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Depth
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kJungleDeepGreen,
                    kJungleMossDark,
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ForgetHeaderWidget(
                      img: forgetPassEmailImage,
                      title: "New Password",
                      subtitle: "Create a strong password to secure your account.",
                    ),
                    const SizedBox(height: 40),
                    
                    // New Password Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Obx(() => TextFormField(
                        controller: controller.newPassword,
                        obscureText: !controller.showPassword.value,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: kJungleCream),
                        decoration: InputDecoration(
                          labelText: "New Password",
                          labelStyle: TextStyle(color: kJungleCream.withValues(alpha: 0.6)),
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: kJungleEmerald),
                          suffixIcon: IconButton(
                            onPressed: () => controller.showPassword.toggle(),
                            icon: Icon(
                              controller.showPassword.value ? Icons.visibility : Icons.visibility_off,
                              color: kJungleCream.withValues(alpha: 0.4),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: kJungleCream.withValues(alpha: 0.1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: kJungleEmerald, width: 1.5),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      )),
                    ),
                    const SizedBox(height: 20),
                    
                    // Confirm Password Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Obx(() => TextFormField(
                        controller: controller.confirmPassword,
                        obscureText: !controller.showPassword.value,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: kJungleCream),
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(color: kJungleCream.withValues(alpha: 0.6)),
                          prefixIcon: const Icon(Icons.lock_reset_rounded, color: kJungleEmerald),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: kJungleCream.withValues(alpha: 0.1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: kJungleEmerald, width: 1.5),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      )),
                    ),
                    const SizedBox(height: 40),
                    
                    // Reset Button
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value ? null : () => controller.resetPassword(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kJungleEmerald,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 10,
                          shadowColor: kJungleEmerald.withValues(alpha: 0.4),
                        ),
                        child: controller.isLoading.value 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text(
                              "UPDATE PASSWORD",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
                            ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
