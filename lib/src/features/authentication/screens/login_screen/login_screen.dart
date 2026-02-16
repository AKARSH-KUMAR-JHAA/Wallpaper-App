import 'package:flutter/material.dart';
import 'package:luminawall/src/features/authentication/screens/login_screen/login_header_widget.dart';
import 'package:luminawall/src/constants/animation_strings.dart';
import 'package:luminawall/src/features/authentication/screens/login_screen/login_form.dart';
import 'package:luminawall/src/features/authentication/screens/sighup_screen/footer_signup_widget.dart';
import 'package:luminawall/src/features/authentication/screens/sighup_screen/signup_screen.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:lottie/lottie.dart';

import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/common_widget/jungle_loading_overlay.dart';
import 'package:luminawall/src/features/authentication/controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomAnimHeight = size.height * 0.25;
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: kJungleMossDark,
      // Fixed background even when keyboard appears
      resizeToAvoidBottomInset: false,
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

          // Bottom Background Animation - Pinned
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Lottie.asset(
              loginAni3,
              fit: BoxFit.fitWidth,
              height: bottomAnimHeight,
            ),
          ),

          // Main Content
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 50,
                ),
                child: Column(
                  children: [
                    const LoginHeaderWidget(
                      img: loginAni2,
                      title: loginTitle,
                      subtitle: loginSubtitle,
                    ),
                    Loginform(size: size),
                    FooterSignupWidget(
                      size: size,
                      txt1: dontHaveAccount,
                      txt2: signup,
                      screen: const SignupScreen(),
                    ),
                    // Large spacer at the bottom
                    SizedBox(height: bottomAnimHeight * 0.2),
                  ],
                ),
              ),
            ),
          ),

          // Full Screen Loading Overlay
          Obx(() {
            if (controller.isLoading.value || controller.isGoogleLoading.value) {
              return const JungleLoadingOverlay(message: "Authenticating...");
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
